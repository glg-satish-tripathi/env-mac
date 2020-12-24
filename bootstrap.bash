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

if [[ "$(id -u)" -eq "0" ]]; then
  echo "please DO NOT run as root";
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

sudo apt-get --assume-yes update
sudo apt-get --assume-yes install \
  unzip \
  jq \
  bat

for SCRIPT in installers/*.install; do
  "${SCRIPT}"
done

rsync \
  --archive \
  --verbose \
  "./home/" \
  "${HOME}"

for FILE in bashrc/*.bash; do
  FILE_NAME="$(basename "${FILE}")"
  # remove section in .bashrc ( eg. #:somefile.bash:[+-] )
  sed -i '/#:'"${FILE_NAME}"':[+]/,/#:'"${FILE_NAME}"':[-]/d' "${HOME}/.bashrc"
  # add the section back
  {
    echo "#:${FILE_NAME}:+"
    cat "${FILE}"
    echo "#:${FILE_NAME}:-"
  } >> "${HOME}/.bashrc"
done
