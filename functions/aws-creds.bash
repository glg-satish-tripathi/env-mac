aws-creds() {
  local account_id role_name access_token region
  account_id="$(aws configure get sso_account_id --profile ${AWS_PROFILE})"
  role_name="$(aws configure get sso_role_name --profile ${AWS_PROFILE})"
  region="$(aws configure get region --profile ${AWS_PROFILE})"
  access_token="$( \
    find ~/.aws/sso/cache -type f ! -name "botocore*.json" -exec stat -c '%X %n' {} \; \
    | sort -nr | cut -d' ' -f2 | head -n1 \
    | xargs jq -r .accessToken \
  )"
  aws sso get-role-credentials \
    --account-id "${account_id}" \
    --role-name "${role_name}" \
    --region "${region:-us-east-1}" \
    --access-token "${access_token}" \
    --no-sign-request \
    --output json \
    | jq -r '.roleCredentials |
      {
        "AWS_ACCESS_KEY_ID": .accessKeyId,
        "AWS_SECRET_ACCESS_KEY": .secretAccessKey,
        "AWS_SESSION_TOKEN": .sessionToken,
        "AWS_CREDENTIALS_EXPIRATION": (.expiration / 1000 | todate)
      } | keys[] as $k | "export \($k)=\(.[$k])"'
}
