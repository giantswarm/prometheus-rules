ifdef PINT_TEAM_FILTER
PINT_FILES_LIST := $(shell grep -l "team:.*${PINT_TEAM_FILTER}" test/tests/providers/capi/capa-mimir/*.rules.yml)
else
PINT_FILES_LIST := $(shell find test/tests/providers/capi/capa-mimir/ -name "*.rules.yml")
endif

.PHONY: clean-dry-run
clean-dry-run: ## dry run for `make clean` - print all untracked files
	@git clean -xnf

.PHONY: clean
clean: ## Clean the git work dir and remove all untracked files
	# clean stage
	git clean -xdf -- test/hack/bin test/hack/output test/hack/checkLabels

##@ Testing

.PHONY: test
test: install-tools template-chart test-rules test-inhibitions test-opsrecipes ## Run all tests

install-tools:
	./test/hack/bin/fetch-tools.sh

template-chart: install-tools ## prepare the helm chart
	test/hack/bin/architect helm template --dir helm/prometheus-rules --dry-run
	bash ./test/hack/bin/template-chart.sh

test-rules: install-tools template-chart ## run unit tests for alerting rules
	bash test/hack/bin/verify-rules.sh "$(test_filter)"

test-inhibitions: install-tools template-chart ## test whether inhibition labels are well defined
	bash test/hack/bin/get-inhibition.sh
	cd test/hack/checkLabels; go run main.go

test-opsrecipes: install-tools template-chart ## Check if opsrecipes are valid
	bash test/hack/bin/check-opsrecipes.sh

test-ci-opsrecipes: install-tools template-chart ## Check if opsrecipes are valid in CI
	test/hack/bin/check-opsrecipes.sh --ci

pint: install-tools template-chart ## Run pint
	GENERATE_ONLY=true bash test/hack/bin/verify-rules.sh
	test/hack/bin/pint -c test/conf/pint/pint-config.hcl lint ${PINT_FILES_LIST}

pint-all: install-tools template-chart ## Run pint with extra checks
	GENERATE_ONLY=true bash test/hack/bin/verify-rules.sh
	test/hack/bin/pint -c test/conf/pint/pint-all.hcl lint ${PINT_FILES_LIST}
