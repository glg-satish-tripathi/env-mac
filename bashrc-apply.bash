#!/usr/bin/env /usr/local/bin/env-ubuntu-core
# NOTE: OSX requires shebang to be binary file not script, this is the workaround
# shellcheck disable=SC1090
. "${SCRIPT_DIR}/core.source"

if [[ "${SCRIPT_DIR}" != "$(readlink -e -- "$(pwd)")" ]]; then
  echo "please execute this script from its own directory"
  exit 1
fi

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
