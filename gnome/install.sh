#!/usr/bin/env bash
# Install the GNOME extensions and restore their settings. Safe to re-run.
# Run gtk/install.sh too, user-theme needs Gruvbox-Dark-Medium in ~/.themes.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="$HOME/.local/bin:$PATH"

# these two are Fedora packages, the rest come from extensions.gnome.org
packages=(pipx gnome-shell-extension-pop-shell gnome-shell-extension-background-logo)
system_extensions=(pop-shell@system76.com background-logo@fedorahosted.org)

rpm -q "${packages[@]}" > /dev/null || sudo dnf install -y "${packages[@]}"
command -v gext > /dev/null || pipx install gnome-extensions-cli --system-site-packages

mapfile -t extensions < "$dir/extensions.txt"
for uuid in "${extensions[@]}"; do
  gnome-extensions info "$uuid" > /dev/null 2>&1 || gext install "$uuid"
done

dconf load /org/gnome/shell/extensions/ < "$dir/extensions.dconf"

# GNOME Shell can't enable an extension until it has seen it after a login
failed=0
for uuid in "${extensions[@]}" "${system_extensions[@]}"; do
  gnome-extensions enable "$uuid" 2> /dev/null || failed=1
done
if [ "$failed" -eq 1 ]; then
  echo "Some extensions could not be enabled, log out and run this again." >&2
fi
