#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/common.sh"

checkOS
bash "$SCRIPT_DIR/prepare.sh"
bash "$SCRIPT_DIR/install-zsh.sh"
echo "success to install zsh"
bash "$SCRIPT_DIR/install-lang.sh"
echo "success to install language"
