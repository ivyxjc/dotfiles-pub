#!/bin/bash
set -e
. ./common.sh
checkOS

echo "+++++++++++++++++++++++++++++++++++"
echo "start install zsh"

# install zsh
if ! command -v zsh &> /dev/null; then
    (installPkg zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi
