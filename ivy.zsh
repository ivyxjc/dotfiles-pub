#!/bin/zsh 
[[ ! -d $HOME/.local/bin ]] || export  PATH="$HOME/.local/bin:$PATH"

# python
[[ ! -d $HOME/.poetry/bin ]] || export PATH="$HOME/.poetry/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion" | \

# rust
[[ ! -f ~/.cargo/env ]] || source ~/.cargo/env

# custom commands
alias i-size='du -sh ./*'
alias i-size-a='du -sh ./* ./.*'
alias i-dos2unix='find . -type f -print0 | xargs -0 dos2unix --'
alias kc='kubectl'
alias vi=vim