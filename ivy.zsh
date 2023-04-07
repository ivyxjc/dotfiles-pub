#!/bin/zsh 
[[ ! -d $HOME/.local/bin ]] || export  PATH="$HOME/.local/bin:$PATH"

[[ ! -f $HOME/.asdf/asdf.sh ]] || . $HOME/.asdf/asdf.sh
[ ! -f $HOME/.asdf/completions/asdf.bash ] || . "$HOME/.asdf/completions/asdf.bash" 

# python
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
[[ ! -d $HOME/.poetry/bin ]] || export PATH="$HOME/.poetry/bin:$PATH"

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion" | \

# rust
[[ ! -f ~/.cargo/env ]] || source ~/.cargo/env


# golang bin
[[ ! -d $HOME/go/bin ]] || export PATH="$HOME/go/bin:$PATH"
[[ ! -d /usr/local/go/bin ]] || export PATH="/usr/local/go/bin:$PATH"

# golang
[[ ! -d /usr/local/go/bin ]] || export PATH="/usr/local/go/bin:$PATH"
[[ ! -d $HOME/go/bin ]] || export PATH="$HOME/go/bin:$PATH"


# custom cd path
alias temp='cd ~/Zero/temp/'
alias zcd='cd ~/Zero/code/'

# custom commands
alias i-size='du -sh ./*'
alias i-size-a='du -sh ./* ./.*'
alias i-dos2unix='find . -type f -print0 | xargs -0 dos2unix --'
alias kc='kubectl'
alias vi=vim
if command -v docker-compose &> /dev/null
then
    alias dc='docker-compose'
fi
