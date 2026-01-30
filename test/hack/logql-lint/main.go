package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/grafana/loki/v3/pkg/logql/syntax"
	"gopkg.in/yaml.v3"
)

const (
	ExitSuccess = 0
	ExitError   = 1
)

// Config holds the validation configuration
type Config struct {
	MandatoryLabels []string
}

// DefaultConfig returns the default configuration
func DefaultConfig() *Config {
	return &Config{
		MandatoryLabels: []string{"cluster_id", "installation"},
	}
}

// PrometheusRule represents the structure of a Prometheus rule file
type PrometheusRule struct {
	APIVersion string `yaml:"apiVersion"`
	Kind       string `yaml:"kind"`
	Metadata   struct {
		Name      string            `yaml:"name"`
		Namespace string            `yaml:"namespace"`
		Labels    map[string]string `yaml:"labels"`
	} `yaml:"metadata"`
	Spec struct {
		Groups []RuleGroup `yaml:"groups"`
	} `yaml:"spec"`
}

// RuleGroup represents a group of rules
type RuleGroup struct {
	Name  string `yaml:"name"`
	Rules []Rule `yaml:"rules"`
}

// Rule represents a single alerting or recording rule
type Rule struct {
	Alert       string            `yaml:"alert,omitempty"`
	Record      string            `yaml:"record,omitempty"`
	Expr        string            `yaml:"expr"`
	For         string            `yaml:"for,omitempty"`
	Labels      map[string]string `yaml:"labels,omitempty"`
	Annotations map[string]string `yaml:"annotations,omitempty"`
}

// ValidationError represents a validation issue
type ValidationError struct {
	File        string
	Group       string
	Rule        string
	Type        string
	Message     string
	Aggregation string
}

// Validator handles validation logic
type Validator struct {
	config *Config
	errors []ValidationError
}

// NewValidator creates a new validator
func NewValidator(config *Config) *Validator {
	return &Validator{
		config: config,
		errors: []ValidationError{},
	}
}

func main() {
	// Parse command line flags
	var (
		mandatoryLabels = flag.String("labels", "cluster_id,installation",
			"Comma-separated list of mandatory labels")
		verbose = flag.Bool("v", false, "Verbose output")
		help    = flag.Bool("h", false, "Show help")
	)
	flag.Parse()

	if *help {
		printHelp()
		os.Exit(ExitSuccess)
	}

	// Parse mandatory labels
	config := &Config{
		MandatoryLabels: strings.Split(*mandatoryLabels, ","),
	}

	// Get files to validate
	files := flag.Args()
	if len(files) == 0 {
		fmt.Fprintln(os.Stderr, "Error: No files specified")
		printHelp()
		os.Exit(ExitError)
	}

	validator := NewValidator(config)

	// Print header
	printHeader(config)

	// Validate each file
	totalFiles := 0
	for _, pattern := range files {
		matches, err := filepath.Glob(pattern)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: Invalid pattern %s: %v\n", pattern, err)
			continue
		}

		for _, file := range matches {
			if *verbose {
				fmt.Printf("Checking: %s\n", file)
			}
			if err := validator.ValidateFile(file); err != nil {
				fmt.Fprintf(os.Stderr, "Error validating %s: %v\n", file, err)
			}
			totalFiles++
		}
	}

	// Print results
	printResults(validator.errors, totalFiles)

	if len(validator.errors) > 0 {
		os.Exit(ExitError)
	}
	os.Exit(ExitSuccess)
}

// ValidateFile validates a single rule file
func (v *Validator) ValidateFile(filepath string) error {
	// Read file
	data, err := os.ReadFile(filepath)
	if err != nil {
		return fmt.Errorf("failed to read file: %w", err)
	}

	// Try to parse as PrometheusRule CRD first
	var rule PrometheusRule
	if err := yaml.Unmarshal(data, &rule); err == nil && rule.Kind == "PrometheusRule" {
		// It's a full CRD
		for _, group := range rule.Spec.Groups {
			for _, r := range group.Rules {
				ruleName := r.Alert
				if ruleName == "" {
					ruleName = r.Record
				}
				v.validateRule(filepath, group.Name, ruleName, r.Expr)
			}
		}
		return nil
	}

	// Try to parse as just a spec (groups only)
	var spec struct {
		Groups []RuleGroup `yaml:"groups"`
	}
	if err := yaml.Unmarshal(data, &spec); err != nil {
		return fmt.Errorf("failed to parse YAML: %w", err)
	}

	// Validate each rule group
	for _, group := range spec.Groups {
		for _, r := range group.Rules {
			ruleName := r.Alert
			if ruleName == "" {
				ruleName = r.Record
			}
			v.validateRule(filepath, group.Name, ruleName, r.Expr)
		}
	}

	return nil
}

// validateRule validates a single rule's expression
func (v *Validator) validateRule(file, group, ruleName, query string) {
	// Parse the LogQL query
	expr, err := syntax.ParseExpr(query)
	if err != nil {
		v.errors = append(v.errors, ValidationError{
			File:    file,
			Group:   group,
			Rule:    ruleName,
			Type:    "syntax_error",
			Message: fmt.Sprintf("Failed to parse query: %v", err),
		})
		return
	}

	// Walk the AST and check aggregations
	v.checkAggregations(file, group, ruleName, expr)
}

// checkAggregations walks the AST and validates aggregations
func (v *Validator) checkAggregations(file, group, ruleName string, expr syntax.Expr) {
	expr.Walk(func(e syntax.Expr) bool {
		if agg, ok := e.(*syntax.VectorAggregationExpr); ok {
			v.validateAggregation(file, group, ruleName, agg)
		}
		return true // Continue walking
	})
}

// validateAggregation checks if an aggregation preserves mandatory labels
func (v *Validator) validateAggregation(file, group, ruleName string, agg *syntax.VectorAggregationExpr) {
	op := agg.Operation
	grouping := agg.Grouping

	// Check if aggregation has grouping
	if grouping == nil {
		v.errors = append(v.errors, ValidationError{
			File:        file,
			Group:       group,
			Rule:        ruleName,
			Type:        "no_grouping",
			Message:     fmt.Sprintf("Aggregation '%s' has no label grouping - all labels will be lost", op),
			Aggregation: agg.String(),
		})
		return
	}

	// Check grouping type
	if grouping.Without {
		// Using 'without' - check that mandatory labels are not excluded
		for _, label := range grouping.Groups {
			if contains(v.config.MandatoryLabels, label) {
				v.errors = append(v.errors, ValidationError{
					File:        file,
					Group:       group,
					Rule:        ruleName,
					Type:        "excluded_label",
					Message:     fmt.Sprintf("Aggregation '%s' excludes mandatory label '%s' in 'without' clause", op, label),
					Aggregation: agg.String(),
				})
			}
		}
	} else {
		// Using 'by' - check that all mandatory labels are included
		for _, mandatoryLabel := range v.config.MandatoryLabels {
			if !contains(grouping.Groups, mandatoryLabel) {
				v.errors = append(v.errors, ValidationError{
					File:        file,
					Group:       group,
					Rule:        ruleName,
					Type:        "missing_label",
					Message:     fmt.Sprintf("Aggregation '%s' missing mandatory label '%s' in 'by' clause", op, mandatoryLabel),
					Aggregation: agg.String(),
				})
			}
		}
	}
}

// Helper functions

func contains(slice []string, item string) bool {
	for _, s := range slice {
		if s == item {
			return true
		}
	}
	return false
}

func printHeader(config *Config) {
	fmt.Println("==================================================")
	fmt.Println("LogQL Aggregation Label Checker")
	fmt.Println("==================================================")
	fmt.Println("Checking that aggregations preserve mandatory labels:")
	for _, label := range config.MandatoryLabels {
		fmt.Printf("  - %s\n", label)
	}
	fmt.Println("==================================================")
	fmt.Println()
}

func printResults(errors []ValidationError, totalFiles int) {
	fmt.Println("==================================================")
	fmt.Println("Summary")
	fmt.Println("==================================================")
	fmt.Printf("Files checked: %d\n", totalFiles)

	if len(errors) == 0 {
		fmt.Println("\033[0;32m✓ All checks passed!\033[0m")
		fmt.Println("\033[0;32m✓ All aggregations preserve mandatory labels\033[0m")
		return
	}

	// Group errors by file
	fileErrors := make(map[string][]ValidationError)
	for _, err := range errors {
		fileErrors[err.File] = append(fileErrors[err.File], err)
	}

	fmt.Printf("\033[0;31m✗ Found %d error(s) in %d file(s)\033[0m\n\n", len(errors), len(fileErrors))

	// Print errors grouped by file
	for file, errs := range fileErrors {
		fmt.Printf("\033[0;31m✗\033[0m %s\n", file)
		for _, err := range errs {
			fmt.Printf("  Group: %s\n", err.Group)
			fmt.Printf("  Rule: %s\n", err.Rule)
			fmt.Printf("  \033[1;33mAggregation:\033[0m %s\n", err.Aggregation)
			fmt.Printf("  \033[0;31mError:\033[0m %s\n", err.Message)
			fmt.Println()
		}
	}

	fmt.Println("Please fix the aggregations to include all mandatory labels.")
}

func printHelp() {
	fmt.Println("LogQL Aggregation Label Checker")
	fmt.Println()
	fmt.Println("Validates that LogQL aggregations preserve mandatory labels.")
	fmt.Println()
	fmt.Println("Usage:")
	fmt.Println("  logql-lint [flags] <files...>")
	fmt.Println()
	fmt.Println("Flags:")
	flag.PrintDefaults()
	fmt.Println()
	fmt.Println("Examples:")
	fmt.Println("  # Check a single file")
	fmt.Println("  logql-lint rules.yml")
	fmt.Println()
	fmt.Println("  # Check multiple files")
	fmt.Println("  logql-lint rules1.yml rules2.yml")
	fmt.Println()
	fmt.Println("  # Check all .logs.yml files")
	fmt.Println("  logql-lint '**/*.logs.yml'")
	fmt.Println()
	fmt.Println("  # Custom mandatory labels")
	fmt.Println("  logql-lint -labels cluster,env,region rules.yml")
	fmt.Println()
	fmt.Println("  # Verbose output")
	fmt.Println("  logql-lint -v rules.yml")
}
