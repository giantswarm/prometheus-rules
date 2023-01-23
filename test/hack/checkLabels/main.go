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
* GLOSSARY
* sourceMatchers and targetMatchers are the labels defined in the alertmanager config file
* sourceLabels are the labels defined in the alerting rules from which originate the inhibitions
* 	--> For example, 'scrape_timeout' is the source label for the 'cancel_if_scrape_timeout' inhibition label
* cancelLabels is another name for the inhibition labels (for example : 'cancel_if_scrape_timeout')
**/
const output = "../output"
const target = "prometheus-rules/templates/alerting-rules"

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
func getTargetsAndSources(config alertConfig.Config, target string) ([]string, string) {
	var targetMatchers []string
	var sourceMatchers []string

	for _, match := range config.InhibitRules {
		for _, targetLabel := range match.TargetMatchers {
			if target == "" {
				targetMatchers = addIfNotPresent(targetMatchers, targetLabel.Name)
			} else if targetLabel.Name == target {
				for _, source := range match.SourceMatchers {
					if source.Value == "true" || source.Value == "false" {
						sourceMatchers = append(sourceMatchers, source.Name)
					}
				}
			} else {
				break
			}
		}
	}

	// To avoid go panicking
	if len(sourceMatchers) == 0 {
		sourceMatchers = append(sourceMatchers, "")
	}

	// return targetMatchers, sourceMatchers
	return targetMatchers, sourceMatchers[0]
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
			target_dir, err := filepath.Abs(output + "/" + dir.Name() + "/" + target)
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

	if len(missingTargetMatchers) > 0 && len(missingSourceLabel) > 0 {
		fmt.Println("## Found %d missing cancel labels\n## Those labels should be define in alertmanager config inhibitions.", len(missingTargetMatchers))
		for _, label := range missingTargetMatchers {
			fmt.Println(label)
		}

		fmt.Printf("## Found %d missing target labels\n## Those labels should be defined by an alert in %q\n", len(missingSourceLabel), target)
		for _, label := range missingSourceLabel {
			fmt.Println(label)
		}

		os.Exit(1)
	} else if len(missingTargetMatchers) > 0 && len(missingSourceLabel) == 0 {
		fmt.Println("## Found %d missing cancel labels\n## Those labels should be define in alertmanager config inhibitions.", len(missingTargetMatchers))
		for _, label := range missingTargetMatchers {
			fmt.Println(label)
		}

		os.Exit(1)
	} else if len(missingTargetMatchers) == 0 && len(missingSourceLabel) > 0 {
		fmt.Printf("## Found %d missing target labels\n## Those labels should be defined by an alert in %q\n", len(missingSourceLabel), target)
		for _, label := range missingSourceLabel {
			fmt.Println(label)
		}

		os.Exit(1)
	} else {
		os.Exit(0)
	}
}
