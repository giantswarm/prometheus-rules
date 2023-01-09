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

const output = "../output"
const target = "prometheus-rules/templates/alerting-rules"

func parseInhibitionFile(fileName string) (alertConfig.Config, error) {
	var inhibitions alertConfig.Config

	// Then one parses the file
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

func getTargets(config alertConfig.Config) ([]string, []string) {
	var targetMatchers []string
	var sourceMatchers []string

	for _, match := range config.InhibitRules {
		for _, target := range match.TargetMatchers {
			targetMatchers = addIfNotPresent(targetMatchers, target.Name)
		}

		for _, source := range match.SourceMatchers {
			sourceMatchers = addIfNotPresent(sourceMatchers, source.Name)
		}
	}

	return targetMatchers, sourceMatchers
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
				for key, _ := range rule.Labels {
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
	var missingLabels []string
	var missingCancelLabels []string
	alertConf, err := parseInhibitionFile("alertmanager.yaml")
	if err != nil {
		return nil, nil, err
	}

	target_output, err := filepath.Abs(output)
	if err != nil {
		return nil, nil, err
	}

	// One iterates over all the different providers' directories
	dirs, _ := ioutil.ReadDir(target_output)
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
	targetLabels, sourceLabels := getTargets(alertConf)

	for _, cancelLabel := range cancelLabels {
		var i = 0

		for _, targetLabel := range targetLabels {
			if cancelLabel == targetLabel {
				i++
			}
		}

		if i == 0 {
			missingCancelLabels = append(missingCancelLabels, cancelLabel)
		}
	}

	for _, source := range sourceLabels {
		var originLabelList = getLabels(rulesList, source)

		// If a label corresponding to source one was not found, one can add it to the list of missing origin labels
		if len(originLabelList) == 0 {
			missingLabels = append(missingLabels, source)
		}
	}

	return missingLabels, missingCancelLabels, nil
}

func main() {
	/* alertConf, _ := parseInhibitionFile("alertmanager.yaml")
	targetLabels, sourceLabels := getTargets(alertConf)

	fmt.Println("source")
	for _, source := range sourceLabels {
		fmt.Println(source)
	}
	fmt.Println("target")
	for _, target := range targetLabels {
		fmt.Println(target)
	} */

	missingTargetLabels, missingCancelLabels, err := getMissingLabels()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("MISSING TARGET LABELS:")
	for _, label := range missingCancelLabels {
		fmt.Println(label)
	}

	fmt.Println("\nMISSING SOURCE LABELS:")
	for _, label := range missingTargetLabels {
		fmt.Println(label)
	}

	// file, fileError := filepath.Abs("alertmanager.yaml")
	// if fileError != nil {
	// 	fmt.Errorf("Error when trying to locate alertmanager.yaml: %v", fileError)
	// }

	// delete := os.Remove(file)
	// if delete != nil {
	// 	fmt.Errorf("Error when trying to delete alertmanager.yaml: %v", delete)
	// }
}
