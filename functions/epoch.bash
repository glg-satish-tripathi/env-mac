# Use 'date' to work on a passed in epoch datetime.
# Supports function parameter or stdin.
# Picks the proper date function depending on MacOS or Linux.
# eg.
#   echo $(epoch 1656207017 +%s)
#   echo 1656207017 | epoch - +"%Y-%m-%dT%H:%M:%S%z"
epoch() {
  local SECONDS
  if [[ "$1" == '-' ]]; then
    SECONDS="$(</dev/stdin cat)"
  else
    SECONDS="$1"
  fi
  shift
  date -r"${SECONDS}" "$@" 2> /dev/null \
    || date --date="@${SECONDS}" "$@" 2> /dev/null \
    || echo 'INVALID_DATE'
}
