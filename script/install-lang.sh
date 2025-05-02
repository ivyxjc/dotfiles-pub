#!/bin/bash
set -e

if ! command -v asdf &> /dev/null; then
    FILE_ARCH=amd64
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            FILE_ARCH=amd64
            ;;
        aarch64)
            FILE_ARCH=arm64
            ;;
        *)
            echo "Not support arch: $ARCH"
            exit 1
            ;;
    esac
    wget https://github.com/asdf-vm/asdf/releases/download/v0.16.7/asdf-v0.16.7-linux-$FILE_ARCH.tar.gz -O /tmp/asdf.tar.gz
    tar -zxvf /tmp/asdf.tar.gz -C /tmp
    sudo mv /tmp/asdf /usr/local/bin/
    rm -rf /tmp/*
fi

# if [[ -z $(asdf plugin list | grep java) ]]; then
#     asdf plugin add java
# fi
# if [[ -z $(asdf list java) ]]; then
#     asdf install java $(asdf latest java temurin-21)
#     asdf global java $(asdf latest java temurin-11)
# fi

# install golang
if [[ -z $(asdf plugin list | grep golang) ]]; then
    asdf plugin add golang
fi
if ! command -v golang &> /dev/null; then
    echo "=========install golang=========="
    asdf install golang $(asdf latest golang)
    asdf set -u golang $(asdf latest golang)
fi

# install python via asdf
if [[ -z $(asdf plugin list | grep python) ]]; then
    asdf plugin add python
fi
if ! command -v python &> /dev/null; then
    echo "=========install python=========="
    asdf install python 3.12.10
    asdf set -u python 3.12.10
fi

# install nodejs
if ! command -v nvm &> /dev/null; then
    echo "==========install nvm=========="
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install lts/jod
    nvm use lts/jod
fi


# install rust
if ! command -v rustup &> /dev/null; then
    echo "==========install rustup=========="
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    rustup update
    rustup component add rust-src
fi

if ! command -v pyenv &> /dev/null; then
    echo "==========install pyenv=========="
    curl https://pyenv.run | bash
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - bash)"
    pyenv install 3.12
    pyenv global 3.12
    rm -rf /tmp/*
fi