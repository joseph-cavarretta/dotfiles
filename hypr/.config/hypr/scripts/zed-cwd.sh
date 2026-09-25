#!/usr/bin/env bash
# Open Zed in the working directory of the focused window (e.g. the shell
# inside a kitty window), falling back to $HOME.

dir="$HOME"
pid=$(hyprctl activewindow -j | jq -r '.pid // empty')

if [[ -n "$pid" && "$pid" != "-1" ]]; then
    # Terminals report their own pid; the shell is a child process
    child=$(pgrep -P "$pid" | head -n1)
    cwd=$(readlink "/proc/${child:-$pid}/cwd" 2>/dev/null)
    [[ -d "$cwd" ]] && dir="$cwd"
fi

exec zeditor "$dir"
