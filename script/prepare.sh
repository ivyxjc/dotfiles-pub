#!/bin/bash
set -e
. ./common.sh
checkOS

echo "+++++++++++++++++++++++++++++++++++"
echo "OS is: $OS"
echo "start prepare"

if [ $OS == "arch" ]; then
    sudo pacman-key --init
    sudo pacman-key --populate
    sudo pacman -Syy
    sudo pacman -S --noconfirm git openssh
    sudo pacman -S archlinuxcn-keyring
    # add archlinuxcn
fi

if [ $OS == "manjaro" ] || [ $OS == "arch" ]; then 
    sudo pacman -Syyu
    sudo pacman -S --noconfirm yay vim neofetch
    if [[ ! -v WSL_DISTRO_NAME ]]; then
        sudo pacman -Rsc --noconfirm fcitx || true
        sudo pacman -S --noconfirm fcitx5 fcitx5-configtool fcitx5-chinese-addons fcitx5-gtk fcitx5-qt
    fi
    sudo pacman -Rsc --noconfirm gnu-netcat  || true
    sudo pacman -S --noconfirm openbsd-netcat
fi

if [ $OS == "ubuntu" ] || [ $OS == "arch" ]; then 
    sudo apt-get update
    sudo apt-get install -y build-essential locales
    # prepare for pyenv
    sudo apt-get install -y libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev curl \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    sudo rm -rf /var/lib/apt/lists/*
    sudo localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
fi

if [ $OS == "centos" ] || [ $OS == "arch" ]; then 
    sudo yum update
fi

if [[ -v WSL_DISTRO_NAME ]]; then
    if [ $OS == "manjaro" ] || [ $OS == "arch" ]; then
        sudo pacman -S base-devel
    fi
else
    (installPkg build-essential -p base-devel)
fi

(installPkg wget curl)
(installPkg git)
(installPkg vim)
(installPkg neovim)
# (installPkg x11-xserver-utils -p xorg-xset -c xorg-xset)
# (installPkg netcat-openbsd -p openbsd-netcat)
