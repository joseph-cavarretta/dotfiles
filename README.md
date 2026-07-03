# dotfiles

Personal configuration files, managed as [GNU Stow](https://www.gnu.org/software/stow/) packages and symlinked into `$HOME`.

## What's Included

| Package | Configures |
|---|---|
| `zsh` | Shell config, aliases, and functions |
| `vim` / `nvim` | Vim with onedark theme; Neovim (lazy.nvim) |
| `tmux` | Terminal multiplexer |
| `kitty` | Terminal emulator |
| `git` | Git config |
| `claude` | Claude Code agents and global CLAUDE.md |
| `hypr` / `waybar` | Hyprland window manager and status bar |
| `vscode` | Editor settings and extensions list |
| `glow` | Markdown viewer theme |

## Usage

Requires GNU Stow (`sudo pacman -S stow` / `sudo apt install stow`).

```bash
git clone https://github.com/joseph-cavarretta/dotfiles.git
cd dotfiles

# symlink everything covered by the Makefile
make all

# or a single package
make zsh
```

Each target runs `stow -t $HOME -R <package>`, so re-running is idempotent and picks up new files. Packages not in the Makefile (`hypr`, `waybar`, `conkyrc`, `vscode`, `glow`) are applied manually.
