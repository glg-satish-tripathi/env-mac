# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
COLOR_CLEAR="\[\e[0m\]"
COLOR_GREEN="\[\e[0;32m\]"
COLOR_LGREEN="\[\e[1;32m\]"
COLOR_YELLOW="\[\e[0;33m\]"
COLOR_RED="\[\e[0;31m\]"
COLOR_CYAN="\[\e[0;36m\]"
COLOR_LCYAN="\[\e[1;36m\]"

git_ps1_info () {
# local EMPTY_TREE_HASH="$(git hash-object -t tree /dev/null)"
# exit if we are not in a git repo
git rev-parse --git-dir > /dev/null 2>&1 || return
# exit if the repo is empty
if ! git log -1 > /dev/null 2>&1; then
  printf "(NEW GIT REPO)"
  return
fi
# assign the branch to a BRANCH variable
local BRANCH="$(git symbolic-ref --short HEAD 2> /dev/null)"
local TRACKING="$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))"
# tracking branch
# git rev-parse --abbrev-ref --symbolic-full-name @{u}
# git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD)

# if not on a named branch, show commit hash
if [ ${#BRANCH} -eq 0 ]; then
  local BRANCH="$(git log -1 --pretty="%h")"
fi

# assign merge parents to BRANCH if we are on a merge commit
local MERGE_BRANCH=$(git log -1 --pretty="%p")
[ ${#MERGE_BRANCH} -gt 7 ] && local BRANCH="${BRANCH}\e[m < ${MERGE_BRANCH}"

# show pending changes in red (does not include untracked files)
git diff --ignore-submodules --quiet HEAD 2>/dev/null >&2
local DIFF=$?
if [ ${DIFF} -eq 1 ]
then
  local COLOR="\e[31m"
else
  local COLOR="\e[m"
fi

printf "\e[33m(${COLOR}${BRANCH}\e[33m -> ${TRACKING})\e[m"
}

ps1_nvm () {
  local NVM SYSTEM VERSION
  NVM="$(nvm version)"
  SYSTEM="$(node -v)"
  VERSION="${NVM/system/${SYSTEM#v}}"
  printf '%s' "js:${VERSION}"
}

export PS1="${COLOR_CLEAR}
${COLOR_YELLOW}\w${COLOR_CLEAR}
\t \$(git_ps1_info) \$(ps1_nvm)
${COLOR_LGREEN}→${COLOR_CLEAR} "
