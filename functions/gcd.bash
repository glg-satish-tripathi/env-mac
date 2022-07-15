gcd () {
	local TARGET
	TARGET="${1}"
	# if not in a git repo, exit
	git rev-parse --show-toplevel &> /dev/null || return

  if [[ "${TARGET}" == /* ]]; then
    cd "${TARGET}" && pwd
  else
    cd "$(git rev-parse --show-toplevel)/${TARGET}" && pwd
  fi
}

_gcd_completions()
{
  # if not in a git repo, exit
  git rev-parse --show-toplevel &> /dev/null || return

  local suggestions revparse
  revparse="$(git rev-parse --show-toplevel)"
  if [ -z "${COMP_WORDS[1]}" ]; then
    suggestions=($(compgen -W "${revparse}"))
  else
    local search="$(find "${COMP_WORDS[1]%/*}" -maxdepth 1 -mindepth 1 -type d -not -name ".*" -name "${COMP_WORDS[1]##*/}*" 2> /dev/null)"
    suggestions=($(compgen -W "${search}"))
  fi
  local debug_tty="/dev/pts/11" # use 'tty' to find number
  echo "${#COMP_WORDS[@]}:'${COMP_WORDS[1]}' s:'${suggestions[*]}' -'${COMP_WORDS[1]%/*}'" &> ${debug_tty}
  COMPREPLY=("${suggestions[@]}")
}

# man builtins
complete -o nospace -F _gcd_completions gcd
