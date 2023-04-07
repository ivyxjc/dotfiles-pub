#!/bin/bash

function checkOS() {
    if [[ -e /etc/debian_version ]]; then
        OS="debian"
        # shellcheck disable=SC1091
        source /etc/os-release

        if [[ $ID == "debian" || $ID == "raspbian" ]]; then
            if [[ $VERSION_ID -lt 8 ]]; then
                echo "⚠️ Your version of Debian is not supported."
                echo ""
                echo "However, if you're using Debian >= 8 or unstable/testing then you can continue, at your own risk."
                echo ""
                until [[ $CONTINUE =~ (y|n) ]]; do
                    read -rp "Continue? [y/n]: " -e CONTINUE
                done
                if [[ $CONTINUE == "n" ]]; then
                    exit 1
                fi
            fi
        elif [[ $ID == "ubuntu" ]]; then
            OS="ubuntu"
            MAJOR_UBUNTU_VERSION=$(echo "$VERSION_ID" | cut -d '.' -f1)
            if [[ $MAJOR_UBUNTU_VERSION -lt 16 ]]; then
                echo "⚠️ Your version of Ubuntu is not supported."
                echo ""
                echo "However, if you're using Ubuntu >= 16.04 or beta, then you can continue, at your own risk."
                echo ""
                until [[ $CONTINUE =~ (y|n) ]]; do
                    read -rp "Continue? [y/n]: " -e CONTINUE
                done
                if [[ $CONTINUE == "n" ]]; then
                    exit 1
                fi
            fi
        fi
    elif [[ -e /etc/system-release ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        if [[ $ID == "fedora" ]]; then
            OS="fedora"
        fi
        if [[ $ID == "centos" ]]; then
            OS="centos"
            if [[ ! $VERSION_ID =~ (7|8) ]]; then
                echo "⚠️ Your version of CentOS is not supported."
                echo ""
                echo "The script only support CentOS 7 and CentOS 8."
                echo ""
                exit 1
            fi
        fi
        if [[ $ID == "amzn" ]]; then
            OS="amzn"
            if [[ $VERSION_ID != "2" ]]; then
                echo "⚠️ Your version of Amazon Linux is not supported."
                echo ""
                echo "The script only support Amazon Linux 2."
                echo ""
                exit 1
            fi
        fi
    elif [[ -e /etc/arch-release ]]; then
        source /etc/os-release
        if [[ $ID == "manjaro" ]]; then
            OS="manjaro"
        else 
            OS="arch"
        fi
    else
        echo "Looks like you aren't running this installer on a Debian, Ubuntu, Fedora, CentOS, Amazon Linux 2 or Arch Linux system"
        exit 1
    fi
}

function updateRepo(){
    if [[ $OS =~ (ubuntu|debian) ]]; then
        sudo apt update
    elif [[ $OS =~ (arch|manjaro) ]]; then
        sudo pacman -Syy
        yay -Syy
    elif [[ $OS =~ (centos|amzn) ]]; then
        sudo yum update
    fi
}

function installPkgInner() {
    echo "--------------------------------"
    if [[ $OS == "ubuntu" ]]; then
        if [[ -z "$UbuntuPkg" ]]; then 
            echo "[  package: $Pkg]"
            sudo apt -y install $Pkg  
        else 
            echo "[  package: $UbuntuPkg]"             
            sudo apt -y install $UbuntuPkg 
        fi
    elif [[ $OS == "debian" ]]; then
        if [[ -z "$DebianPkg" ]]; then 
            echo "[  package: $Pkg]"
            sudo apt -y install $Pkg
        else 
            echo "[  package: $DebianPkg]"
            sudo apt -y install $DebianPkg
        fi
    elif [[ $OS == manjaro ]] || [[ $OS == arch ]]; then
        if [[ ! -z "$PacmanPkg" ]]; then 
            echo "[  package: $PacmanPkg]" 
            sudo pacman -S --noconfirm $PacmanPkg
        elif [[ ! -z "$YayPkg" ]]; then 
            echo "[  package(aur): $YayPkg]"
            yay -S $YayPkg
        else 
            echo "[  package: $Pkg]"
            sudo pacman -S $Pkg
        fi
    elif [[ $OS == centos ]]; then
        if [[ -z "$CentosPkg" ]]; then 
            echo "[  package: $Pkg]"
            sudo yum install $Pkg
        else 
            echo "[  package: $CentosPkg]"
            sudo yum install $CentosPkg
        fi
    fi
}

# sample:
# installPkg git -p git2

function installPkg(){
    Pkg="$1"
    shift
    while getopts ":p:y:d:u:c:" opt; do
        case $opt in
            # manjaro pacman
            p) PacmanPkg="$OPTARG"
            ;;
            # manjaro yay
            y) YayPkg="$OPTARG"
            ;;
            # debian
            d) DebianPkg="$OPTARG"
            ;;
            # ubuntu
            u) UbuntuPkg="$OPTARG"
            ;;
            # centos
            c) CentosPkg="$OPTARG"
            ;;
            \?) echo "Invalid option -$OPTARG" >&2
        exit 1
        ;;
        esac
        case $OPTARG in
            -*) echo "Option $opt needs a valid argument"
            exit 1
            ;;
        esac
    done
    echo $UbuntuPkg
    installPkgInner
}