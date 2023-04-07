#!/bin/bash
set -e

if [[ ! -d ~/.asdf ]]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3
fi

source ~/.asdf/asdf.sh

if [[ -z $(asdf plugin list | grep java) ]]; then
        asdf plugin add java
fi


if [[ -z $(asdf list java) ]]; then
    asdf install java $(asdf latest java temurin-11)
    # asdf install java $(asdf latest java temurin-17)
    asdf global java $(asdf latest java temurin-11)
fi

# install golang
if ! command -v node &> /dev/null; then
    echo "=========install golang=========="
    (VERSION=1.20.3;DISTRO=linux-amd64;wget https://go.dev/dl/go$VERSION.$DISTRO.tar.gz;rm -rf /usr/loca/go && sudo tar -C /usr/local -xzf go$VERSION.$DISTRO.tar.gz)
fi


# install nodejs
if ! command -v nvm &> /dev/null; then
    echo "==========install nvm=========="
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install v18.15.0
    nvm use v18.15.0
fi


# install rust
if ! command -v rustup &> /dev/null; then
    echo "==========install rustup=========="
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source "$HOME/.cargo/env"
    rustup update
    rustup component add rust-src
fi

if ! command -v pyenv &> /dev/null; then
    echo "==========install pyenv=========="
    curl https://pyenv.run | bash
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    pyenv install 3.10.9
    pyenv global 3.10.9
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
fi
