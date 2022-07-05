
#!/bin/bash

#
# This test ensures that all prometheus rules are valid
#

set -eu

START_TIME="$(date +%s)"
echo "$(date '+%H:%M:%S') promtool: start"

GIT_WORKDIR=$(git rev-parse --show-toplevel)

PROMTOOL=test/hack/bin/promtool
HELM=test/hack/bin/helm
ARCHITECT=test/hack/bin/architect

array_contains() {
	local search="$1"
	local element
	shift
	for element; do
		if [[ "${element}" == "${search}" ]]; then
			return 0
		fi
	done
	return 1
}


expected_failure_relative_file="test/hack/allowlist/.promtool_ignore"
expected_failure_file="${GIT_WORKDIR}/${expected_failure_relative_file}"

# Retrieve all files we're going to check
all_files=()
while read -r line || [[ -n "${line}" ]]; do
	all_files+=("${line}")
done < <(git ls-files | grep "helm/prometheus-rules/templates/alerting-rules" | sed -e 's|^helm/prometheus-rules/||' | grep -Ee '\.(yml)$')

# Get prefixes whitelisted via the failure_file
expected_failure_prefixes=()
# [[ -n "$line" ]] is used to also read the last line if the file has no trailing new line
while read -r line || [[ -n "${line}" ]]; do
	expected_failure_prefixes+=("${line}")
done < "${expected_failure_file}"

providers=()
while read -r line || [[ -n "${line}" ]]; do
    providers+=("${line}")
done < <(cat ${GIT_WORKDIR}/test/hack/allowlist/providers)

for file in "${all_files[@]}"; do

	# check if the ${file} is whitelisted via the ${expected_failure_file}
	array_contains "${file}" "${expected_failure_prefixes[@]}" && whitelisted=$? || whitelisted=$?

	# if it is not whitelisted add the error to new_shellcheck_errors
	if [[ "${whitelisted}" -ne "0" ]]; then
		echo ${file}
		#new_shellcheck_errors+=("${shellcheck_result_entry}")
	    for provider in "${providers[@]}"; do
	        echo ${provider}

			filename=${file##*/}

	        helm template --set="managementCluster.provider.kind=${provider}" --release-name prometheus-rules --namespace giantswarm ./helm/prometheus-rules -s ${file} | yq '.spec' - > ${GIT_WORKDIR}/test/providers/${provider}/${filename}
			promtool check rules ${GIT_WORKDIR}/test/providers/${provider}/${filename}
			#promtool test rules ${GIT_WORKDIR}/test/providers/${provider}/${file}.test
			# todo:
			# append file to a list of files with error and print a summary at the end
			#find ${GIT_WORKDIR}/test/providers/${provider} -name '${file##*/}.test.yml' -print0 | xargs -0 promtool test rules
			find ${GIT_WORKDIR}/test/providers/${provider} -name ${filename%.yml}.test.yml -print0 | xargs -0 promtool test rules
	    done	
	fi
done

#TODO clean git state
# undo architect modifications
# git checkout -- helm/prometheus-rules/Chart.yaml
# git checkout -- helm/prometheus-rules/values.yaml


echo "$(date '+%H:%M:%S') promtool: end (Elapsed time: $(($(date +%s) - START_TIME))s)"
