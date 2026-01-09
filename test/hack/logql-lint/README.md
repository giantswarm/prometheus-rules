# LogQL Aggregation Label Checker

A tool for validating LogQL aggregations

## Installation

```bash
# From the tools/logql-lint directory
cd tools/logql-lint

# Build the binary
go build -o logql-lint

# Or install to a specific location
go build -o ../../test/hack/bin/logql-lint
```

## Usage

### Basic Usage

```bash
# Check a single file
./logql-lint rules.yml

# Check multiple files
./logql-lint rules1.yml rules2.yml

# Check all .logs.yml files in a directory (requires shell expansion)
./logql-lint path/to/rules/**/*.logs.yml

# Verbose output
./logql-lint -v rules.yml
```

### Custom Mandatory Labels

```bash
# Specify custom mandatory labels
./logql-lint -labels cluster,env,region rules.yml

# Default labels are: cluster_id,installation
```

## How It Works

```
YAML File → Parse YAML → Extract LogQL → Loki Parser → AST → Walk Tree → Validate → Report
```

1. **Read YAML** - Parses PrometheusRule CRD files
2. **Extract Queries** - Gets expr fields from rules
3. **Parse LogQL** - Uses Loki's official parser to create AST
4. **Walk AST** - Finds all VectorAggregationExpr nodes
5. **Validate** - Checks label preservation rules
6. **Report** - Groups errors by file with clear messages

## Validation Rules

### Rule 1: Aggregations Must Have Grouping
```logql
# ❌ INVALID - No grouping clause
sum(rate({job="test"}[5m]))

# ✅ VALID - Has grouping
sum(rate({job="test"}[5m])) by (cluster_id, installation, pipeline, provider)
```

### Rule 2: 'by' Must Include All Mandatory Labels
```logql
# ❌ INVALID - Missing mandatory labels
sum(rate({job="test"}[5m])) by (cluster_id)

# ✅ VALID - All mandatory labels present
sum(rate({job="test"}[5m])) by (cluster_id, installation, pipeline, provider, namespace)
```

### Rule 3: 'without' Must Not Exclude Mandatory Labels
```logql
# ❌ INVALID - Excludes mandatory label
sum(rate({job="test"}[5m])) without (cluster_id)

# ✅ VALID - Only excludes non-mandatory labels
sum(rate({job="test"}[5m])) without (pod, container)
```

## Extending with New Rules

Adding new validation rules is straightforward:

```go
// Example: Check for expensive regex operations
func (v *Validator) checkExpensiveOperations(expr syntax.Expr) {
    syntax.Walk(expr, func(e syntax.Expr) {
        if matcher, ok := e.(*syntax.MatchersExpr); ok {
            // Check for problematic regex patterns
            for _, m := range matcher.Mts {
                if m.Type == labels.MatchRegexp && strings.HasPrefix(m.Value, ".*") {
                    v.errors = append(v.errors, ValidationError{
                        Message: "Regex starting with .* is expensive",
                    })
                }
            }
        }
    })
}
```

## Exit Codes

- `0` - All validations passed
- `1` - Validation errors found or runtime error

## Troubleshooting

### "failed to parse query"
- Check LogQL syntax with lokitool first
- Ensure query is valid LogQL

### "No files specified"
- Make sure you're passing file paths as arguments
- Use quotes for glob patterns: `"**/*.logs.yml"`

## Future Enhancements

Possible additions:
- [ ] Query performance hints (expensive regex, large time ranges)
- [ ] Best practices checking (filter before parse, use indexed labels)
- [ ] JSON output for CI integration
- [ ] Configuration file support (.logql-lint.yaml)
- [ ] Ignore patterns / exceptions
- [ ] Label consistency across files
- [ ] Integration with pre-commit hooks
