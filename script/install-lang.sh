#!/bin/bash
set -e

# Use environment variables from bootstrap.sh, default to true for standalone execution
INSTALL_GOLANG=${INSTALL_GOLANG:-true}
INSTALL_PYTHON=${INSTALL_PYTHON:-true}
INSTALL_NODE=${INSTALL_NODE:-true}
INSTALL_RUST=${INSTALL_RUST:-true}

# install golang via asdf
if [[ "$INSTALL_GOLANG" == true ]]; then
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
        echo "==========install asdf=========="
        wget https://github.com/asdf-vm/asdf/releases/download/v0.16.7/asdf-v0.16.7-linux-$FILE_ARCH.tar.gz -O /tmp/asdf.tar.gz
        tar -zxvf /tmp/asdf.tar.gz -C /tmp
        sudo mv /tmp/asdf /usr/local/bin/
        rm -f /tmp/asdf.tar.gz
    fi

    if [[ -z $(asdf plugin list 2>/dev/null | grep golang) ]]; then
        asdf plugin add golang
    fi
    if ! command -v go &> /dev/null; then
        echo "==========install golang=========="
        asdf install golang $(asdf latest golang)
        asdf set -u golang $(asdf latest golang)
    fi
fi

# install python via pyenv
if [[ "$INSTALL_PYTHON" == true ]]; then
    if ! command -v pyenv &> /dev/null; then
        echo "==========install pyenv=========="
        curl https://pyenv.run | bash
        export PYENV_ROOT="$HOME/.pyenv"
        [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init - bash)"
    fi
    if ! pyenv versions 2>/dev/null | grep -q "3.13"; then
        echo "==========install python 3.13=========="
        pyenv install 3.13
        pyenv global 3.13
    fi
fi

# install nodejs via fnm
if [[ "$INSTALL_NODE" == true ]]; then
    if ! command -v fnm &> /dev/null; then
        echo "==========install fnm=========="
        curl -fsSL https://fnm.vercel.app/install | bash
        export PATH="$HOME/.local/share/fnm:$PATH"
        eval "$(fnm env)"
    fi
    if ! fnm list 2>/dev/null | grep -q "v24"; then
        echo "==========install node 24=========="
        fnm install 24
        fnm default 24
    fi
fi

# install rust via rustup
if [[ "$INSTALL_RUST" == true ]]; then
    if ! command -v rustup &> /dev/null; then
        echo "==========install rustup=========="
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        rustup update
        rustup component add rust-src
    fi
fi
