OS := $(shell uname -s)
STOW := stow -t $(HOME) -R -d $(CURDIR)

# Packages stowed on every platform
COMMON := zsh vim nvim tmux kitty git

.PHONY: all common linux $(COMMON) glow vscode hypr waybar conky harness

all: common glow vscode harness
ifeq ($(OS),Linux)
all: linux
endif

common: $(COMMON)

$(COMMON):
	$(STOW) $@

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

# Claude Code instructions, settings, hooks, style guide, and the delegation MCP server live in
# agent-dev-harness. Clone it into ~/dev (replacing a leftover antigravity-mcp symlink from when the
# server lived here) and run its installer.
harness:
	@mkdir -p "$(HOME)/dev"
	@if [ -L "$(HOME)/dev/antigravity-mcp" ]; then rm "$(HOME)/dev/antigravity-mcp"; fi
	@if [ ! -d "$(HOME)/dev/agent-dev-harness" ]; then \
		git clone git@github.com:joseph-cavarretta/agent-dev-harness.git "$(HOME)/dev/agent-dev-harness"; \
	fi
	$(MAKE) -C "$(HOME)/dev/agent-dev-harness" install
