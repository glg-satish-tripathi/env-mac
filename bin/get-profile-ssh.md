# get-profile-ssh.md

## requirements

### environment variables

- MY_PROFILE (eg. personal, company-name, etc.)

### bitwarden secure note(s)

- note needs to be in a folder called `profile-MY_PROFILE` (replace `MY_PROFILE` with the contents of what would be in the environment variable)

- note needs 4 fields
  - private - base64 encoded private key
  - public - base 64 encoded public key
  - name - file name of the private key (eg. `id_rsa`, etc.)
  - type - should always be `ssh`

> **NOTE**: use `base64 -w0` to encode