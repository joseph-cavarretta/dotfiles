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
| `claude` | Claude Code base config (`CLAUDE.base.md`), settings, hooks | both |
| `glow` | Markdown viewer theme | both |
| `vscode` | Editor settings and extensions list | both |
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

Bootstrap a fresh knowledge base from the vault scaffold (never overwrites an existing one):

```bash
make vault-init   # copies vault/ -> ~/.vault
```

## Runtime dependencies

Configs assume these tools are present (install per platform):

- **git** — `gh` on `PATH` (used as the credential helper).
- **nvim** — a Nerd Font, `ripgrep` + `fd` + `make` (telescope), and a clipboard provider
  (`wl-clipboard`/`xclip` on Linux; built-in on macOS). LSP servers install via Mason.
- **vim** — plugins are submodules; run `git submodule update --init --recursive` after cloning.
- **glow** — theme is resolved via `GLAMOUR_STYLE` (set in `.zshenv`).
- **macOS bluetooth helpers** (`bt_on`/`bt_off`/`bt_status`) — `brew install blueutil`.
- **VSCode extensions** — restore with
  `xargs -n1 code --install-extension < vscode/vscode-extensions.txt`.
- **Arch desktop** (Hyprland) — `mpvpaper` plus a video wallpaper at
  `~/.wallpaper/…mp4` and the launcher `~/.local/bin/mpvpaper-loop.sh` (both machine-local,
  not tracked here).
