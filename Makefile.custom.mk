.PHONY: clean-dry-run
clean-dry-run: ## dry run for `make clean` - print all untracked files
	@git clean -xnf

.PHONY: clean
clean: ## Clean the git work dir and remove all untracked files
	# clean stage
	git clean -xdf -- test/hack/bin test/hack/output
	git checkout -- helm/prometheus-rules/Chart.yaml
	git checkout -- helm/prometheus-rules/values.yaml

##@ Testing

.PHONY: test
test: install-tools template-chart test-rules test-inhibitions restore-chart

test-rules: install-tools template-chart
	# run unit tests for alerting rules
	bash test/hack/bin/verify-rules.sh "$(test_filter)"

install-tools:
	./test/hack/bin/fetch-tools.sh

template-chart: install-tools
	# prepare the helm chart
	test/hack/bin/architect helm template --dir helm/prometheus-rules --dry-run

test-inhibitions: install-tools template-chart
	# test whether inhibition labels are well defined
	./test/hack/bin/get-inhibition.sh
	./test/hack/bin/template-chart.sh
	cd test/hack/checkLabels; go run main.go

restore-chart:
	@## Revert Chart version
	@yq e -i '.version = "[[ .Version ]]"' helm/prometheus-rules/Chart.yaml
	@yq e -i '.appVersion = "[[ .AppVersion ]]"' helm/prometheus-rules/Chart.yaml
	@yq e -i '.project.branch = "[[ .Branch ]]"' helm/prometheus-rules/values.yaml
	@yq e -i '.project.commit = "[[ .SHA ]]"' helm/prometheus-rules/values.yaml
