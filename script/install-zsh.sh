#!/bin/bash
set -e
. ./common.sh
checkOS

echo "+++++++++++++++++++++++++++++++++++"
echo "start install zsh"

# install zsh
if ! command -v zsh &> /dev/null; then
    (installPkg zsh)
    wget https://git.io/antigen -O ~/antigen.zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
