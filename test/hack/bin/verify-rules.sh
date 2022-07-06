#!/bin/bash

#
# This test ensures that all prometheus rules are valid
#

set -eu

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

START_TIME="$(date +%s)"
echo "$(date '+%H:%M:%S') promtool: start"

GIT_WORKDIR=$(git rev-parse --show-toplevel)

PROMTOOL=test/hack/bin/promtool
HELM=test/hack/bin/helm
ARCHITECT=test/hack/bin/architect

# prepare the helm chart
${ARCHITECT} helm template --dir ${GIT_WORKDIR}/helm/prometheus-rules --dry-run

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

promtool_check_errors=()
promtool_test_errors=()

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

			# don't run tests if no provider specific tests are defined
			if [[ -d ${GIT_WORKDIR}/test/providers/${provider} ]]; then
	        	${HELM} template --set="managementCluster.provider.kind=${provider}" --release-name prometheus-rules --namespace giantswarm ./helm/prometheus-rules -s ${file} | yq '.spec' - > ${GIT_WORKDIR}/test/providers/${provider}/${filename}

				${PROMTOOL} check rules ${GIT_WORKDIR}/test/providers/${provider}/${filename} 

				find ${GIT_WORKDIR}/test/providers/${provider} -name ${filename%.yml}.test.yml -print0 | xargs -0 ${PROMTOOL} test rules

			fi
	    done	
	fi
done



# TODO clean git state
# - undo architect modifications
#   - git checkout -- helm/prometheus-rules/Chart.yaml
#   - git checkout -- helm/prometheus-rules/values.yaml
# - shfmt + shellcheck
# - make script output nice


# if [[ ${#promtool_test_errors[@]} -eq 0 || ${#promtool_check_errors[@]} -eq 0 ]]; then
# 	echo "Congratulations!  All prometheus rules have been promtool checked."
# else
# 	{
# 		echo
# 		echo "Please review the below errors."
# 		echo
# 		for err in "${promtool_test_errors[@]}"; do
# 			echo "  $err"
# 		done
# 
# 		for err in "${promtool_check_errors[@]}"; do
# 			echo "  $err"
# 		done
# 	} >&2
# 	false
# fi

echo "$(date '+%H:%M:%S') promtool: end (Elapsed time: $(($(date +%s) - START_TIME))s)"
