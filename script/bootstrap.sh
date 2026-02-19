#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/common.sh"

# Default: install nothing unless specified
INSTALL_BUILD=false
INSTALL_ZSH=false
INSTALL_GOLANG=false
INSTALL_PYTHON=false
INSTALL_NODE=false
INSTALL_RUST=false

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Options:
    --all           Install everything
    --build         Install build dependencies (prepare.sh)
    --zsh           Install zsh + oh-my-zsh + powerlevel10k
    --lang          Install all languages (golang, python, node, rust)
    --golang        Install golang via asdf
    --python        Install python via pyenv
    --node          Install node via fnm
    --rust          Install rust via rustup
    -h, --help      Show this help message

Examples:
    $(basename "$0") --all                    # Install everything
    $(basename "$0") --build --zsh            # Install build deps and zsh
    $(basename "$0") --lang                   # Install all languages
    $(basename "$0") --python --node          # Install only python and node
EOF
    exit 0
}

# Parse arguments
if [[ $# -eq 0 ]]; then
    usage
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            INSTALL_BUILD=true
            INSTALL_ZSH=true
            INSTALL_GOLANG=true
            INSTALL_PYTHON=true
            INSTALL_NODE=true
            INSTALL_RUST=true
            shift
            ;;
        --build)
            INSTALL_BUILD=true
            shift
            ;;
        --zsh)
            INSTALL_ZSH=true
            shift
            ;;
        --lang)
            INSTALL_GOLANG=true
            INSTALL_PYTHON=true
            INSTALL_NODE=true
            INSTALL_RUST=true
            shift
            ;;
        --golang)
            INSTALL_GOLANG=true
            shift
            ;;
        --python)
            INSTALL_PYTHON=true
            shift
            ;;
        --node)
            INSTALL_NODE=true
            shift
            ;;
        --rust)
            INSTALL_RUST=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

checkOS
echo "OS detected: $OS"

# Export language flags for install-lang.sh
export INSTALL_GOLANG INSTALL_PYTHON INSTALL_NODE INSTALL_RUST

if [[ "$INSTALL_BUILD" == true ]]; then
    echo "========== Installing build dependencies =========="
    bash "$SCRIPT_DIR/prepare.sh"
    echo "✓ Build dependencies installed"
fi

if [[ "$INSTALL_ZSH" == true ]]; then
    echo "========== Installing zsh =========="
    bash "$SCRIPT_DIR/install-zsh.sh"
    echo "✓ Zsh installed"
fi

if [[ "$INSTALL_GOLANG" == true ]] || [[ "$INSTALL_PYTHON" == true ]] || [[ "$INSTALL_NODE" == true ]] || [[ "$INSTALL_RUST" == true ]]; then
    echo "========== Installing languages =========="
    bash "$SCRIPT_DIR/install-lang.sh"
    echo "✓ Languages installed"
fi

echo ""
echo "========== Installation complete =========="
