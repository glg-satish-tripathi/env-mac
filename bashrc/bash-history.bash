# History date format
export HISTTIMEFORMAT="%y/%m/%d %T "
# Ignore dupliate commands even if there is a space difference, and don't save them to history
export HISTCONTROL="erasedups:ignoreboth:ignorespace"
# Number of commands to save
export HISTSIZE=-1
# History maxiumum file size
export HISTFILESIZE=-1
# Ignore exit commands from history
export HISTIGNORE="&:[ ]*:exit"
# Never overwrise history, always append
shopt -s histappend
# Multiline commands become one line
shopt -s cmdhist
