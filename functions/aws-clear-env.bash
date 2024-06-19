aws-clear-env() {
  VARS=()
  while IFS= read -r line; do
    VARS+=("$line")
  done < <(env | awk -F'=' '/^AWS_/ {print $1}')
  unset "${VARS[@]}"
  unset HTTP_PROXY HTTPS_PROXY
}
