#!/bin/sh
# Arch-only overrides, pulled in by geninclude in kitty.conf.
# Prints nothing on other OSes, so kitty.conf defaults apply there.

. /etc/os-release 2>/dev/null
[ "$ID" = "arch" ] || exit 0

# Match Obsidian's 0.85 window opacity (see hyprland.conf)
echo "background_opacity 0.85"
