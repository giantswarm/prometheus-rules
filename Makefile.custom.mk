.PHONY: clean-dry-run
clean-dry-run: ## dry run for `make clean` - print all untracked files
	@git clean -xnf

.PHONY: clean
clean: ## Clean the git work dir and remove all untracked files
	# clean stage
	git clean -xdf -- test/hack/bin test/hack/output test/hack/checkLabels

##@ Testing

.PHONY: test
test: install-tools template-chart test-rules test-inhibitions test-runbooks ## Run all tests

install-tools:
	./test/hack/bin/fetch-tools.sh

template-chart: install-tools ## prepare the helm chart
	bash ./test/hack/bin/template-chart.sh

test-rules: install-tools template-chart ## run unit tests for alerting rules
	bash test/hack/bin/verify-rules.sh "$(test_filter)" "${rules_type}"

test-inhibitions: install-tools template-chart ## test whether inhibition labels are well defined
	bash test/hack/bin/get-inhibition.sh
	cd test/hack/checkLabels; go run main.go

test-runbooks: install-tools template-chart ## Check if runbooks are valid
	bash test/hack/bin/check-runbooks.sh

test-ci-runbooks: install-tools template-chart ## Check if runbooks are valid in CI
	test/hack/bin/check-runbooks.sh --ci

pint: install-tools template-chart ## Run pint
	GENERATE_ONLY=true bash test/hack/bin/verify-rules.sh
	./test/hack/bin/run-pint.sh test/conf/pint/pint-config.hcl ${PINT_TEAM_FILTER}

pint-all: install-tools template-chart ## Run pint with extra checks
	GENERATE_ONLY=true bash test/hack/bin/verify-rules.sh
	./test/hack/bin/run-pint.sh test/conf/pint/pint-all.hcl ${PINT_TEAM_FILTER}

##@ Mixins
update-mimir-mixin: install-tools ##        Update Mimir mixins
	./mimir/update.sh

update-loki-mixin: install-tools ##        Update Loki mixins
	./loki/update.sh

update-mixin: update-mimir-mixin update-loki-mixin ##        Update all mixins
