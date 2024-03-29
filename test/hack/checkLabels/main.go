package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"

	promv1 "github.com/prometheus-operator/prometheus-operator/pkg/apis/monitoring/v1"
	alertConfig "github.com/prometheus/alertmanager/config"
	"sigs.k8s.io/yaml"
)

/*
* This program detects errors in inhibitions configuration.
* It verifies and reports any missing elements from the following:
* - target labels (`cancel_if_*`) are actually defined in some `target_matchers` Inhibition definition
* - source labels from `source_matchers` Inhibition definition are defined by some Alerts
*
* In order for an alert to be inhibited we need 3 elements :
* - an Alert with some source labels
* - an Inhibition definition mapping source labels to target labels
* - an Alert with some target labels
*
* example:
* - Alert `ScrapeTimeout` has label `scrape_timeout=true`
* - Inhibition definition says `source_matchers: [scrape_timeout=true], target_matchers: [cancel_if_scrape_timeout=true]` (leaving out the equal part to simplify)
* - Alert `MyAlert` has label `cancel_if_scrape_timeout=true`
*
* GLOSSARY
* https://github.com/giantswarm/prometheus-rules/#inhibitions
* am_sourceMatchers and am_targetMatchers are the labels defined in the alertmanager config file
* sourceLabels are the labels defined in the alerting rules from which originate the inhibitions
* 	--> For example, 'scrape_timeout' is the source label for the 'cancel_if_scrape_timeout' inhibition label
* cancelLabels is another name for the inhibition labels (for example : 'cancel_if_scrape_timeout')
**/
const output = "../output"
const alertRulesPath = "prometheus-rules/templates/alerting-rules"

// Parse the alertmanager config file
func parseInhibitionFile(fileName string) (alertConfig.Config, error) {
	var inhibitions alertConfig.Config

	f, err := os.ReadFile(fileName)
	if err != nil {
		return alertConfig.Config{}, err
	}

	parseErr := yaml.Unmarshal(f, &inhibitions)
	if parseErr != nil {
		return alertConfig.Config{}, err
	}

	return inhibitions, nil
}

// Return either the list of target or a specific source label from the alertmanager config file
// If no target is specified in the function's parameters, the function will return the targetMatchers list from the config and an empty list of sourceMatchers
func getTargetsAndSources(config alertConfig.Config, target string) ([]string, string) {
	var am_targetMatchers []string
	var am_sourceMatchers []string

	for _, match := range config.InhibitRules {
		for _, targetLabel := range match.TargetMatchers {
			if target == "" {
				am_targetMatchers = addIfNotPresent(am_targetMatchers, targetLabel.Name)
			} else if targetLabel.Name == target {
				for _, source := range match.SourceMatchers {
					// Checking the source's value as all inhibition labels are booleans but not all sourceMatchers are (clusterid for example)
					if source.Value == "true" || source.Value == "false" {
						am_sourceMatchers = append(am_sourceMatchers, source.Name)
					}
				}
			}
		}
	}

	// To avoid go panicking
	if len(am_sourceMatchers) == 0 {
		return am_targetMatchers, ""
	}

	// return am_targetMatchers, am_sourceMatchers
	return am_targetMatchers, am_sourceMatchers[0]
}

func parseYaml(data []byte) (promv1.PrometheusRule, error) {
	var p promv1.PrometheusRule

	err := yaml.Unmarshal(data, &p)
	if err != nil {
		return promv1.PrometheusRule{}, err
	}

	return p, nil
}

func addIfNotPresent(array []string, newValue string) []string {
	for _, label := range array {
		if label == newValue {
			return array
		}
	}

	array = append(array, newValue)

	return array
}

func getLabels(ruleList []promv1.PrometheusRule, matcher string) []string {
	var labelList []string

	for _, p := range ruleList {
		for _, group := range p.Spec.Groups {
			for _, rule := range group.Rules {
				for key := range rule.Labels {
					// When the targetted label is found, adds it to the list if not already present in it
					if matcher == "cancel_if_" && strings.HasPrefix(key, matcher) {
						labelList = addIfNotPresent(labelList, key)
					} else if key == matcher {
						labelList = addIfNotPresent(labelList, matcher)
					}
				}
			}
		}
	}

	return labelList
}

func getMissingLabels() ([]string, []string, error) {
	var rulesList []promv1.PrometheusRule
	var missingSourceLabels []string
	var missingTargetMatchers []string
	alertConf, err := parseInhibitionFile("alertmanager.yaml")
	if err != nil {
		return nil, nil, err
	}

	target_output, err := filepath.Abs(output)
	if err != nil {
		return nil, nil, err
	}

	// One iterates over all the different providers' directories
	dirs, err := ioutil.ReadDir(target_output)
	if err != nil {
		return nil, nil, err
	}
	for _, dir := range dirs {
		if dir.IsDir() {
			target_dir, err := filepath.Abs(output + "/" + dir.Name() + "/" + alertRulesPath)
			if err != nil {
				return nil, nil, err
			}

			// One iterates over all the content of the alerting-rules directory
			items, _ := ioutil.ReadDir(target_dir)
			for _, item := range items {
				if !item.IsDir() {
					// If the current item is a file, read its content
					f, err := os.ReadFile(target_dir + "/" + item.Name())
					if err != nil {
						return nil, nil, err
					}

					// Parse the file content...
					p, err := parseYaml(f)
					if err != nil {
						return nil, nil, err
					}

					// .. And adds the resulting rule to the prometheus-rules list
					rulesList = append(rulesList, p)

				}
			}
		}
	}

	// Get the list of labels with prefix "cancel_if_"
	cancelLabels := getLabels(rulesList, "cancel_if_")
	targetLabels, _ := getTargetsAndSources(alertConf, "")

	for _, cancelLabel := range cancelLabels {
		var i = 0

		for _, targetLabel := range targetLabels {
			if cancelLabel == targetLabel {
				i++

				// Limitation: we check the first source matchers found as we expect at least one source matcher for each target matcher. But there could be multiple and this part could be improved.
				_, source := getTargetsAndSources(alertConf, cancelLabel)
				var originLabelList = getLabels(rulesList, source)

				if len(originLabelList) == 0 {
					missingSourceLabels = addIfNotPresent(missingSourceLabels, source)
				}
				break
			}
		}

		if i == 0 {
			missingTargetMatchers = append(missingTargetMatchers, cancelLabel)
		}
	}

	return missingSourceLabels, missingTargetMatchers, nil
}

func main() {
	missingSourceLabel, missingTargetMatchers, err := getMissingLabels()
	if err != nil {
		log.Fatal(err)
	}

	if len(missingTargetMatchers) > 0 || len(missingSourceLabel) > 0 {
		if len(missingTargetMatchers) > 0 {
			fmt.Println("## Found %d missing target labels\n## Those labels should be defined in source_matchers field in alertmanager's inhibit_rule config.", len(missingTargetMatchers))
			for _, label := range missingTargetMatchers {
				fmt.Println(label)
			}
		}
		if len(missingSourceLabel) > 0 {
			fmt.Printf("## Found %d missing source labels\n## Those labels should be defined by an alert in %q\n", len(missingSourceLabel), alertRulesPath)
			for _, label := range missingSourceLabel {
				fmt.Println(label)
			}
		}

		os.Exit(1)
	} else {
		os.Exit(0)
	}
}
