.PHONY: build
build: ## Build the logql-lint binary
	go build -o logql-lint .

.PHONY: test
test: build ## Run tests
	./logql-lint --help
	@echo "Running validation on test files..."
	@if [ -d ../../test/hack/output/generated ]; then \
		./logql-lint ../../test/hack/output/generated/capa/platform/*/*.logs.yml 2>&1 | head -50; \
	else \
		echo "No generated test files found. Run 'make template-chart' first."; \
	fi

.PHONY: clean
clean: ## Clean build artifacts
	rm -f logql-lint

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
