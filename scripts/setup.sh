#!/bin/bash

set -e

echo "=== Config Setup Script ==="
echo ""

# Helper function to ask for confirmation
confirm() {
    read -p "$1 [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "This script is for macOS only."
    exit 1
fi

# Homebrew
echo "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed."
    if confirm "Install Homebrew?"; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is required. Exiting."
        exit 1
    fi
else
    echo "Homebrew is already installed."
fi
echo ""

# Fish shell via Homebrew
echo "Checking for fish..."
if brew list fish &> /dev/null; then
    echo "  fish is already installed."
else
    echo "  Installing fish..."
    brew install fish
fi
echo ""

# Kitty via curl
echo "Checking for kitty..."
if command -v kitty &> /dev/null; then
    echo "  kitty is already installed."
else
    echo "  Installing kitty..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
fi
echo ""

# Nerd Font
echo "Checking for SauceCodePro Nerd Font..."
if ls ~/Library/Fonts/*SauceCodePro* &> /dev/null || ls /Library/Fonts/*SauceCodePro* &> /dev/null; then
    echo "  Font is already installed."
else
    if confirm "Install SauceCodePro Nerd Font via Homebrew?"; then
        brew install --cask font-sauce-code-pro-nerd-font
    else
        echo "  Skipping font install. Download manually from https://www.nerdfonts.com/font-downloads"
    fi
fi
echo ""

# mise
echo "Checking for mise..."
if ! command -v mise &> /dev/null; then
    echo "mise is not installed."
    if confirm "Install mise?"; then
        curl https://mise.run | sh
        echo "mise installed. You may need to restart your terminal before continuing."
    else
        echo "mise is required for remaining tools. Exiting."
        exit 1
    fi
else
    echo "mise is already installed."
fi
echo ""

# mise tools
MISE_TOOLS="neovim ripgrep fd"
echo "Installing via mise: $MISE_TOOLS"
for tool in $MISE_TOOLS; do
    if mise list "$tool" 2>/dev/null | grep -q "$tool"; then
        echo "  $tool is already installed."
    else
        echo "  Installing $tool..."
        mise use -g "$tool@latest"
    fi
done
echo ""

# Fish as default shell
echo "Checking default shell..."
FISH_PATH=$(which fish)
if [[ "$SHELL" == "$FISH_PATH" ]]; then
    echo "Fish is already the default shell."
else
    echo "Current shell: $SHELL"
    if confirm "Change default shell to fish? (requires sudo)"; then
        if ! grep -q "$FISH_PATH" /etc/shells; then
            echo "Adding fish to /etc/shells..."
            echo "$FISH_PATH" | sudo tee -a /etc/shells
        fi
        chsh -s "$FISH_PATH"
        echo "Default shell changed to fish. Restart your terminal to use it."
    else
        echo "Skipping shell change."
    fi
fi
echo ""

# Fisher and fish plugins
echo "Checking for fisher (fish plugin manager)..."
if fish -c "type -q fisher" 2>/dev/null; then
    echo "Fisher is already installed."
else
    echo "Installing fisher..."
    fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
fi

echo "Installing fish plugins..."
fish -c 'fisher install jethrokuan/z' 2>/dev/null || echo "  z plugin may already be installed."
echo ""

echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal"
echo "  2. Open Neovim - plugins will install automatically"
echo "  3. Run :Mason in Neovim to install language servers"
