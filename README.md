# dotfiles

Personal configuration files, managed as [GNU Stow](https://www.gnu.org/software/stow/) packages and symlinked into `$HOME`. Cross-platform: macOS and Arch Linux.

## What's Included

| Package | Configures | Platform |
|---|---|---|
| `zsh` | Shell config, aliases, and functions | both |
| `vim` | Vim with onedark theme; plugins as native `pack/` submodules | both |
| `nvim` | Neovim (lazy.nvim), modular `lua/` config | both |
| `tmux` | Terminal multiplexer | both |
| `kitty` | Terminal emulator | both |
| `git` | Git config | both |
| `glow` | Markdown viewer theme | both |
| `vscode` | Editor settings and extensions list | both |
| `zed` | Editor settings | both |
| `hypr` | Hyprland window manager | Linux |
| `waybar` | Status bar | Linux |
| `conky` | Desktop system monitor | Linux |

## Usage

Requires GNU Stow (`sudo pacman -S stow` / `brew install stow`).

```bash
git clone --recurse-submodules https://github.com/joseph-cavarretta/dotfiles.git
cd dotfiles

# symlink everything for this OS (detected via uname)
make all

# or a single package
make zsh
```

`make all` is OS-aware: it stows the common packages plus `glow`/`vscode` (with the correct
per-OS paths) on both platforms, and additionally installs `hypr`/`waybar`/`conky` on Linux.
Each target runs `stow -t $HOME -R <package>`, so re-running is idempotent.

## AI agent setup

Claude Code instructions, permissions, guardrail hooks, the Python style guide, the vault scaffold,
and the delegation MCP server live in [agent-dev-harness](https://github.com/joseph-cavarretta/agent-dev-harness).
`make all` runs `make harness`, which clones it into `~/dev/agent-dev-harness` and runs its installer.

## Runtime dependencies

Configs assume these tools are present (install per platform):

- **git** — `gh` on `PATH` (used as the credential helper).
- **nvim** — a Nerd Font, `ripgrep` + `fd` + `make` (telescope), and a clipboard provider
  (`wl-clipboard`/`xclip` on Linux; built-in on macOS). LSP servers install via Mason.
- **vim** — plugins are submodules; run `git submodule update --init --recursive` after cloning.
- **glow** — theme is resolved via `GLAMOUR_STYLE` (set in `.zshenv`).
- **harness** — `jq` and `uv` (see the agent-dev-harness README).
- **macOS bluetooth helpers** (`bt_on`/`bt_off`/`bt_status`) — `brew install blueutil`.
- **VSCode extensions** — restore with
  `xargs -n1 code --install-extension < vscode/vscode-extensions.txt`.
- **Arch desktop** (Hyprland) — `mpvpaper` plus a video wallpaper at
  `~/.wallpaper/…mp4` and the launcher `~/.local/bin/mpvpaper-loop.sh` (both machine-local,
  not tracked here).
