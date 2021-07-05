nvmrc () {
  # swtich to the nodejs version automatically, if an .nvmrc file is found in the current dir.
  [[ -f .nvmrc ]] || return 0
  local CURRENT_VERSION="$(node -v)"
  local DESIRED_VERSION="$(<.nvmrc)"
  if [[ "${CURRENT_VERSION//[$'\r\t\n v']}" != "${DESIRED_VERSION//[$'\r\t\n v']}" ]]; then
    nvm use "${DESIRED_VERSION//[$'\r\t\n v']}"
    echo
  fi
}
