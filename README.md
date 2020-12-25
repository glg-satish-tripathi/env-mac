# env-ubuntu

## Setup

### EC2 User Data

```bash
#!/bin/bash
git clone https://github.com/datfinesoul/env-ubuntu.git /home/ubuntu/env-ubuntu
chown -R ubuntu:ubuntu /home/ubuntu/env-ubuntu
sudo -Hu ubuntu bash -c "cd && cd env-ubuntu && ./bootstrap.bash"
```

### Installing Manually

```bash
# curl 'github static link here' | bash -c
```

## Commands

- `profile <name>`

  sets the **MY_PROFILE** and **BW_SESSION** environment variables (logs the user into bitwarden)

- `get-profile-ssh-keys.bash`

  pulls down the ssh keys tied to **MY_PROFILE** ([read more](./bin/get-profile-ssh.md))

- `save-profile-ssh-key.bash PROFILE_NAME KEY_NAME ...`

  - **KEY_NAME** is required, and used as a base pattern.

    ```bash
    # eg.
    save-profile-ssh-key.bash personal id_rsa
    # this saves the following files to the "personal" profile
    # - id_rsa
    # - id_rsa.pub
    ```

    