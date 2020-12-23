#!/usr/bin/env bash
SCRIPT="$(readlink -e -- "${0}")"
SCRIPT_DIR="$(dirname "${SCRIPT}")"

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o errexit
set -o nounset
set -o pipefail
IFS=$'\n\t'

if [[ "${SCRIPT_DIR}" != "$(pwd)" ]]; then
  echo "please execute this script from its own directory"
  exit 1
fi

if [[ "$(id -u)" -ne "0" ]]; then
  echo "please run with sudo";
  exit 1
fi

function cleanup {
  ls /tmp/*.log
  :
}
trap cleanup EXIT

#cp hidden files
#shopt -s dotglob nullglob
#files=(*)
#echo "There are ${#files[@]} files here, including dot files and subdirs"

LOG="/tmp/bootstrap.bash.log"

# log stdout/stderr to a file and stdout
exec &> >(tee "${LOG}")

apt update
apt-get --assume-yes install \
  unzip \
  jq

for SCRIPT in installers/*.install; do
  "${SCRIPT}"
done

rsync \
  --archive \
  --verbose \
  ./home/* \
  "${HOME}"

for FILE in bashrc/*.bash; do
  if grep -e "$(head -n1 "${FILE}")" "${HOME}/.bashrc"; then
    echo "FOUND"
  else
    echo "NOTFOUND"
  fi
done
