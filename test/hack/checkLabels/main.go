package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"

	promv1 "github.com/prometheus-operator/prometheus-operator/pkg/apis/monitoring/v1"
	"sigs.k8s.io/yaml"
)

const output = "../output"
const target = "prometheus-rules/templates/alerting-rules"

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

func getMissingLabels() ([]string, error) {
	var rulesList []promv1.PrometheusRule
	var missingLabels []string

	target_output, err := filepath.Abs(output)
	if err != nil {
		return nil, err
	}

	// One iterates over all the different providers' directories
	dirs, err := ioutil.ReadDir(target_output)
	if err != nil {
		return nil, err
	}
	for _, dir := range dirs {
		if dir.IsDir() {
			target_dir, err := filepath.Abs(output + "/" + dir.Name() + "/" + target)
			if err != nil {
				return nil, err
			}

			// One iterates over all the content of the alerting-rules directory
			items, _ := ioutil.ReadDir(target_dir)
			for _, item := range items {
				if !item.IsDir() {
					// If the current item is a file, read its content
					f, err := os.ReadFile(target_dir + "/" + item.Name())
					if err != nil {
						return nil, err
					}

					// Parse the file content...
					p, err := parseYaml(f)
					if err != nil {
						return nil, err
					}

					// .. And adds the resulting rule to the prometheus-rules list
					rulesList = append(rulesList, p)

				}
			}
		}
	}

	// Get the list of labels with prefix "cancel_if_"
	cancelLabels := getLabels(rulesList, "cancel_if_")

	for _, cancelLabel := range cancelLabels {
		var originLabel = strings.Split(cancelLabel, "cancel_if_")
		if len(originLabel) < 2 {
			return nil, fmt.Errorf("No origin label found in %q", cancelLabel)
		}

		var originLabelList = getLabels(rulesList, originLabel[1])

		// If a label corresponding to the "cancel_if_" prefixed one was not found, one can add it to the list of missing origin labels
		if len(originLabelList) == 0 {
			missingLabels = append(missingLabels, originLabel[1])
		}
	}

	return missingLabels, nil
}

func main() {
	missingLabels, err := getMissingLabels()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("MISSING LABELS:")
	for _, label := range missingLabels {
		fmt.Println(label)
	}
}
