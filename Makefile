OS := $(shell uname -s)
STOW := stow -t $(HOME) -R -d $(CURDIR)

# Packages stowed on every platform
COMMON := zsh vim nvim tmux kitty git

.PHONY: all common linux $(COMMON) claude glow vscode hypr waybar conky vault-init

all: common claude glow vscode
ifeq ($(OS),Linux)
all: linux
endif

common: $(COMMON)

$(COMMON):
	$(STOW) $@

# claude uses --no-folding so real local files (settings.json, CLAUDE.md) can coexist
claude:
	$(STOW) --no-folding claude

# Linux-only desktop packages
linux: hypr waybar conky

hypr waybar conky:
	$(STOW) $@

# glow: XDG (~/.config/glow) on both; macOS glow also reads ~/Library/Preferences/glow,
# so mirror the files there. GLAMOUR_STYLE (set in .zshenv) covers the theme regardless.
glow:
	$(STOW) glow
ifeq ($(OS),Darwin)
	@mkdir -p "$(HOME)/Library/Preferences/glow"
	@ln -sf "$(CURDIR)/glow/.config/glow/glow.yml" "$(HOME)/Library/Preferences/glow/glow.yml"
	@ln -sf "$(CURDIR)/glow/.config/glow/atom-one-dark.json" "$(HOME)/Library/Preferences/glow/atom-one-dark.json"
endif

# vscode: User settings dir differs per OS and isn't stow-shaped, so symlink directly.
# Restore extensions with: xargs -n1 code --install-extension < vscode/vscode-extensions.txt
vscode:
ifeq ($(OS),Darwin)
	@mkdir -p "$(HOME)/Library/Application Support/Code/User"
	@ln -sf "$(CURDIR)/vscode/settings.json" "$(HOME)/Library/Application Support/Code/User/settings.json"
else
	@mkdir -p "$(HOME)/.config/Code/User"
	@ln -sf "$(CURDIR)/vscode/settings.json" "$(HOME)/.config/Code/User/settings.json"
endif

# Bootstrap a fresh knowledge base from the vault/ scaffold. Never overwrites an existing vault.
vault-init:
	@if [ -e $(HOME)/.vault ]; then \
		echo "~/.vault already exists — not overwriting"; \
	else \
		cp -r $(CURDIR)/vault $(HOME)/.vault && echo "bootstrapped ~/.vault from scaffold"; \
	fi
