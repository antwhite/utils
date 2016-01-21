# Fix Path
PATH=$PATH:/usr/local/sbin:~/Code/utils

# Unbreak broken, non-colored terminal
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Erase duplicates in history
export HISTCONTROL=erasedups
# Store 10k history entries
export HISTSIZE=10000
# Append to the history file when exiting instead of overwriting it
shopt -s histappend

# RBEnv
eval "$(rbenv init -)"

# NVM
. `brew --prefix nvm`/nvm.sh
export NVM_DIR=~/.nvm

# Bash Completion
. `brew --prefix`/etc/bash_completion

# Autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# Helpers
alias tw='open -a /Applications/TextWrangler.app'
alias start=open

#Prompt

export PROMPT_COMMAND=__prompt_command  # Func to gen PS1 after CMDs
function __prompt_command() {
    local EXIT="$?"             # This needs to be first
    PS1=""
    
    if [ $EXIT != 0 ]; then
        PS1+="❌ "
    else
        PS1+="✅ "
    fi

    PS1+="\u@"`currentip.js`":\w\n\\$\[$(tput sgr0)\] "
    
    history -a; 
    history -c; 
    history -r;
}
