#!/bin/sh
# Arch-only rules, run by `exec` in hyprland.conf on every start/reload.
# Does nothing on other distros.

. /etc/os-release 2>/dev/null
[ "$ID" = "arch" ] || exit 0

# Zed: match Obsidian/kitty's 0.85 opacity
hyprctl keyword windowrule 'opacity 0.85 0.85, match:class ^(dev\.zed\.Zed)$'
