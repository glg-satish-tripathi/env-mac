gs (){
	local tld="$(git rev-parse --show-toplevel 2> /dev/null)" || tld=''
	local command="${1}"
	if [[ -z "${tld}" ]]; then
		return
	fi
	if [[ -z "${command}" || ! -e "${tld}/_dev/gs-targets/${command}" ]]; then
		find "${tld}"/_dev/gs-targets -type l -printf '%f\n'
		return
	fi
	"${tld}/dev/gs-targets/${command}"
}
