#!/usr/bin/env bash
# Link the GTK themes into place and fetch the icon pack. Safe to re-run.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/.themes" "$HOME/.icons"
for theme in "$dir"/themes/*; do
  ln -sfn "$theme" "$HOME/.themes/$(basename "$theme")"
done

# libadwaita apps ignore gtk-theme, they only read ~/.config/gtk-4.0
ln -sfn "$HOME/.themes/Gruvbox-Dark-Medium/gtk-4.0" "$HOME/.config/gtk-4.0"

# the icon pack is 1.6 GB per variant, too big to track here
if [ ! -d "$HOME/.icons/Gruvbox-Plus-Dark" ]; then
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  git clone --depth 1 https://github.com/SylEleuth/gruvbox-plus-icon-pack.git "$tmp/icons"
  mv "$tmp/icons/Gruvbox-Plus-Dark" "$HOME/.icons/"
fi

gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark-Medium'
gsettings set org.gnome.desktop.interface icon-theme 'Gruvbox-Plus-Dark'
