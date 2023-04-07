#!/bin/bash
. ./common.sh

checkOS
bash prepare.sh
bash install-zsh.sh
echo "success to install zsh"
bash install-lang.sh
echo "success to install language"
