# obtain AWS env vars related to an access key
# get AWS MFA device
# fetch 2FA token via the AWS_BW_TOTP related BW login
# auth with AWS MFA device to obtain fully authed temp creds
function awslogin {
  unset AWS_SESSION_TOKEN AWS_CSM_ENABLED AWS_CSM_PORT AWS_CSM_HOST
  local BW_LOOKUP="${1:?missing bitwarden token}"
  local AWS_MFA_TOKEN

  >&2 echo -e "\n:: fetching environment and authenticator"
  bw_env "${BW_LOOKUP}"

  >&2 echo -e ":: fetching mfa device"
  AWS_MFA_ARN="$(aws iam list-mfa-devices | \
    jq -cr '.MFADevices[0].SerialNumber')"
  if [[ ! "${AWS_MFA_ARN}" =~ ^arn:.* ]]; then
    >&2 echo ":: Unable to locate MFA device"
    return 1
  fi

  #if [[ -z "${2:-}" ]]; then
    #>&2 echo
    #IFS=$'\n\t' read -sp 'Enter MFA token from your MFA device: ' AWS_MFA_TOKEN
  #fi
  AWS_MFA_TOKEN="$(bw get totp "${AWS_BW_TOTP}")"
  if [[ -z "${AWS_MFA_TOKEN:-}" ]]; then
    >&2 echo 'missing MFA token'
    return 1
  fi

  >&2 echo ":: obtaining aws security credentials"

  #43200-12h
  #21600-6h
  #3600=1h
  #900=15m
  IFS=$'\n\t' read -r ID KEY TOKEN <<< "$( \
    aws \
    sts get-session-token \
    --serial-number "$AWS_MFA_ARN" \
    --token "${AWS_MFA_TOKEN}" \
    --duration-seconds 21600 | \
    jq -rc '.Credentials | [.AccessKeyId,.SecretAccessKey,.SessionToken] | @tsv' \
    )"

  if [[ true ]]; then
    AWS_CSM_ENABLED=true
    AWS_CSM_PORT=31000
    AWS_CSM_HOST=127.0.0.1
    export AWS_CSM_ENABLED AWS_CSM_PORT AWS_CSM_HOST
  fi

  AWS_ACCESS_KEY_ID="${ID}"
  AWS_SECRET_ACCESS_KEY="${KEY}"
  AWS_SESSION_TOKEN="${TOKEN}"
  export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
}
