#!/usr/bin/env bash
# Re-export extension settings. Run this after changing them, dconf can't be
# symlinked so extensions.dconf is only a snapshot.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# only the extensions we use, dconf keeps settings for removed ones forever
keep='^[[](appindicator|arcmenu|blur-my-shell|caffeine|clipboard-indicator|just-perfection|media-controller|pop-shell|rounded-window-corners-reborn|user-theme)[]/]'
# runtime state, not preferences
state='^(last-announced-version|prefs-visible-page|recently-installed-apps|update-notifier-project-version|user-enabled)='

dconf dump /org/gnome/shell/extensions/ \
  | awk -v keep="$keep" -v state="$state" '/^\[/ { p = ($0 ~ keep) } p && $0 !~ state' \
  > "$dir/extensions.dconf"
