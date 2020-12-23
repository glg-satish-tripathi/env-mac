# vi: noet :
# noet because we need tabs for the heredoc
profile () {
	unset -v MY_PROFILE BW_SESSION
	local PROFILE_NAME="${1}"
	local PROFILE_DB="${HOME}/.my_profiles.json"

	if [[ -z "${PROFILE_NAME}" ]]; then
		# multiple choice if no profile was provided
		local PROFILES="$(<"${PROFILE_DB}" jq -r '.[].name')"

		select PROFILE_CHOICE in $PROFILES
		do
			# if an invalid profile was selected exit
			if [[ -z "${PROFILE_CHOICE}" ]]; then
				>&2 echo "invalid profile"
				return 1
			fi

			export MY_PROFILE="${PROFILE_CHOICE}"
			break
		done < /dev/tty
	else
		# validate the entered profile against the list
		local PROFILE_MATCH="$( \
			<"${PROFILE_DB}" jq -r --from-file <(cat <<- DOC
			.[]
			| select(.name | test("^${PROFILE_NAME}$"))
			| .name
		DOC
		))"

		# if no profile was found in the config, exit
		if [[ -z "${PROFILE_MATCH}" ]]; then
			>&2 echo "invalid profile"
			return 1
		fi

		export MY_PROFILE="${PROFILE_MATCH}"
	fi

	if ! bw login --check &> /dev/null; then
		BW_SESSION="$(bw login --raw)"
	else
		BW_SESSION="$(bw unlock --raw)"
	fi
	export BW_SESSION
	bw sync
}
