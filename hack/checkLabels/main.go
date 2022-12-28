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

func parseYaml(data []byte) (promv1.PrometheusRule, error) {
	var p promv1.PrometheusRule

	err := yaml.Unmarshal(data, &p)
	if err != nil {
		log.Fatal(err)
	}

	return p, err
}

func addIfNotPresent(array []string, newValue string) []string {
	var i = 0

	for _, label := range array {
		if strings.Compare(label, newValue) == 0 {
			i++
		}
	}

	// Checks if the newValue  is already in the array and if not, adds it
	if i == 0 {
		array = append(array, newValue)
	}

	return array
}

func getLabels(ruleList []promv1.PrometheusRule, matcher string) []string {
	var labelList = make([]string, 0)

	for _, p := range ruleList {
		for _, group := range p.Spec.Groups {
			for _, rule := range group.Rules {
				for key, _ := range rule.Labels {
					// When the targetted label is found, adds it to the list if not already present in it
					if matcher == "cancel_if_" && strings.Contains(key, matcher) {
						labelList = addIfNotPresent(labelList, key)
					} else if strings.Compare(key, matcher) == 0 {
						labelList = addIfNotPresent(labelList, matcher)
					}
				}
			}
		}
	}

	return labelList
}

func findMissingLabels(cancelLabels []string, presentOriginLabels []string) []string {
	var expectedOriginLabels = make([]string, 0)
	var missingLabels = make([]string, 0)

	// Add the expected labels to the list : labels corresponding to the "cancel_if_" prefix ones without this prefix
	for _, cancelLabel := range cancelLabels {
		expectedOriginLabels = append(expectedOriginLabels, strings.Split(cancelLabel, "cancel_if_")[1])
	}

	for _, expected := range expectedOriginLabels {
		var i = 0

		for _, present := range presentOriginLabels {
			if strings.Compare(expected, present) == 0 {
				i++
			}
		}

		// One compares the expected labels with the actual one and adds each missing label to the missingLables array
		if i == 0 {
			missingLabels = append(missingLabels, expected)
		}
	}

	return missingLabels
}

func getMissingLabels() []string {
	target_dir, _ := filepath.Abs("../output/prometheus-rules/templates/alerting-rules")

	var rulesList = make([]promv1.PrometheusRule, 0)
	var presentOriginLabels = make([]string, 0)

	// One iterates over all the content of the alerting-rules directory
	items, _ := ioutil.ReadDir(target_dir)
	for _, item := range items {
		if !item.IsDir() {
			// If the current item is a file, read its content
			f, err := os.ReadFile(target_dir + "/" + item.Name())
			if err != nil {
				log.Fatal(err)
			}

			// Parse the file content...
			p, err := parseYaml(f)
			if err != nil {
				log.Fatal(err)
			}

			// .. And adds the resulting rule to the prometheus-rules list
			rulesList = append(rulesList, p)

		}
	}

	// Get the list of labels with prefix "cancel_if_"
	cancelLabels := getLabels(rulesList, "cancel_if_")

	for _, cancelLabel := range cancelLabels {
		var originLabel = getLabels(rulesList, (strings.Split(cancelLabel, "cancel_if_"))[1])

		// If a label corresponding to the "cancel_if_" prefixed one was found, one can add it to the list of found origin labels
		if len(originLabel) > 0 {
			presentOriginLabels = append(presentOriginLabels, originLabel[0])
		}
	}

	// Creates and returns the list of missing labels
	var missingLabels = findMissingLabels(getLabels(rulesList, "cancel_if_"), presentOriginLabels)

	return missingLabels
}

func main() {
	missingLabels := getMissingLabels()
	fmt.Println("MISSING")
	fmt.Println(missingLabels)
}
