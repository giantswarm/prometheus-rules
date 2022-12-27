.PHONY: clean-dry-run
clean-dry-run: ## dry run for `make clean` - print all untracked files
	@git clean -xnf

.PHONY: clean
clean: ## Clean the git work dir and remove all untracked files
	# clean stage
	git clean -xdf -- test/
	git checkout -- helm/prometheus-rules/Chart.yaml
	git checkout -- helm/prometheus-rules/values.yaml

##@ Testing

.PHONY: test
test: install-tools ## run unit tests for alerting rules
	bash test/hack/bin/verify-rules.sh "$(test_filter)"
	./hack/bin/template-chart.sh
	go run hack/checkLabels/main.go
	rm -R ./hack/output/prometheus-rules

install-tools:
	./test/hack/bin/fetch-tools.sh
