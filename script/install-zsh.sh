#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/common.sh"
checkOS

echo "+++++++++++++++++++++++++++++++++++"
echo "start install zsh"

# install zsh
if ! command -v zsh &> /dev/null; then
    installPkg zsh
fi

# install oh-my-zsh (required for .zshrc)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "==========install oh-my-zsh=========="
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# install powerlevel10k theme
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    echo "==========install powerlevel10k=========="
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# zinit will be auto-installed when zsh starts (defined in .zshrc)
echo "zinit and plugins will be installed on first zsh launch"
