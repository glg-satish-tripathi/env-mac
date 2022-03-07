#!/usr/bin/env /home/phadviger/env-ubuntu/env-ubuntu-core
# NOTE: OSX requires shebang to be binary file not script, this is the workaround
# shellcheck disable=SC1090
. "${SCRIPT_DIR}/core.source"

if [[ "${SCRIPT_DIR}" != "$(readlink -e -- "$(pwd)")" ]]; then
  echo "please execute this script from its own directory"
  exit 1
fi

# this needs to be cleared to make sure old files are not included in later
# package installations
rm -rf "${HOME}/.vim"

# copy files and dirs to the home folder (additive)
rsync \
  --archive \
  --verbose \
  "./home/.vim" \
  "${HOME}/"
rsync \
  --archive \
  --verbose \
  "./home/.vimrc" \
  "${HOME}/.vimrc"

# vim specific stuff
pushd "${HOME}/.vim/pack/datfinesoul/start/coc.nvim"
npm install
popd
