
.PHONY: test
test: install-tools
	./test/hack/bin/verify-rules.sh
	# make target install tools 
	# do architect generate
	# helm template --release-name cluster-api-monitoring --namespace giantswarm ./helm/prometheus-rules -s templates/alerting-rules/capi.rules.yml
	# write 

install-tools:
	./test/hack/bin/fetch-tools.sh

.PHONY: clean-dry-run
clean-dry-run: ## dry run for `make clean` - print all untracked files
	@git clean -xnf


.PHONY: clean
clean: ## Clean the git work dir and remove all untracked files
	# clean stage
	@git clean -xdf

