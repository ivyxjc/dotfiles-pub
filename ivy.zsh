#!/bin/zsh
[[ ! -d $HOME/.local/bin ]] || export PATH="$HOME/.local/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv &> /dev/null && eval "$(pyenv init - zsh)"

# fnm (node version manager)
[[ -d $HOME/.local/share/fnm ]] && export PATH="$HOME/.local/share/fnm:$PATH"
command -v fnm &> /dev/null && eval "$(fnm env --use-on-cd)"

# rust
[[ ! -f ~/.cargo/env ]] || source ~/.cargo/env

# custom commands
alias i-size='du -sh ./*'
alias i-size-a='du -sh ./* ./.*'
alias i-dos2unix='find . -type f -print0 | xargs -0 dos2unix --'
alias kc='kubectl'
alias vi=vim
