git-branch-clean () {
	local BRANCH
	BRANCH="${1}"

	if [[ -n "${BRANCH}" ]]; then
		git branch --merged "${BRANCH}" \
			| awk '/^\s+/ {print $1}' \
			| xargs -I '{}' git branch -d '{}'
	else
		>&2 echo "missing branch"
	fi
}
