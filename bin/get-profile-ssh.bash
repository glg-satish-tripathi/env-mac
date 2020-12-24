#!/usr/bin/env bash
# vi: noet :

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o errexit
set -o nounset
set -o pipefail
IFS=$'\n\t'

# obtain folderid from bitwarden based on MY_PROFILE
FOLDER_ID="$( \
	bw get folder "profile-${MY_PROFILE}" \
	| jq -rM '.id' \
	)"

if [[ -z "${FOLDER_ID}" ]]; then
	>&2 echo ":: unable to obtain folderid from bitwarden"
	exit 1
fi

if ! bw unlock --check > /dev/null 2>&1; then
	>&2 echo ":: bitwarden profile is locked"
	exit 1
fi

# 1. obtain array of ssh keys from bitwarden
# 2. put each item as a base64 encoded string on a separate line
DATA="$( \
	bw list items \
	--folderid "${FOLDER_ID}" \
	| jq -rM --from-file <(cat <<- DOC
		map(
			select(.fields)
			| .fields
			| from_entries
			| select(.type == "ssh")
		)
		| .[]
		| @base64
DOC
))"

for ROW in $(echo "${DATA}"); do
	_jq() {
		echo ${ROW} | base64 --decode | jq -r ${1}
	}

	PRIVATE="$(_jq '.private' | base64 --decode)"
	PUBLIC="$(_jq '.public' | base64 --decode)"
	KEY_FILE="${HOME}/.ssh/$(_jq '.name')"

	echo "${PUBLIC}" > "${KEY_FILE}.pub"
	echo "${PRIVATE}" > "${KEY_FILE}"
	chmod 400 "${KEY_FILE}.pub" "${KEY_FILE}"
done


