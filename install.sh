#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install zsh if missing
if ! command -v zsh &>/dev/null; then
  echo "Installing zsh..."
  sudo apt update && sudo apt install -y zsh
fi

# Install oh-my-zsh if missing
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Symlink config files
symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  [ -e "$dst" ] && mv "$dst" "${dst}.bak" && echo "Backed up existing $dst"
  ln -sf "$src" "$dst"
  echo "Linked $dst"
}

symlink "$DOTFILES_DIR/.zshrc"                  "$HOME/.zshrc"
symlink "$DOTFILES_DIR/.p10k.zsh"               "$HOME/.p10k.zsh"
symlink "$DOTFILES_DIR/.gitconfig"              "$HOME/.gitconfig"
symlink "$DOTFILES_DIR/.dir_colors/dircolors"   "$HOME/.dir_colors/dircolors"

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting zsh as default shell..."
  chsh -s "$(which zsh)"
fi

echo ""
echo "Done! Restart your terminal or run: exec zsh"
