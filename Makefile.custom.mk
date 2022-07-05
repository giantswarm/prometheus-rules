
.PHONY: test
test: 
	# make target install tools 
	# do architect generate
	# helm template --release-name cluster-api-monitoring --namespace giantswarm ./helm/prometheus-rules -s templates/alerting-rules/capi.rules.yml
	# write 

install-tools:
	# move download into separate script
	# download architect (latest stable)
	# download helm
	# curl prometheus, extract and only run `promtool`

clean:
	# clean stage

# test for all providers:
# "openstack" "vcd" "vsphere" "gcp" "aws"