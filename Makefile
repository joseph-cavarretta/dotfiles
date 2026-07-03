STOW := stow -t $(HOME) -R -d $(CURDIR)

.PHONY: all claude git kitty nvim tmux vim zsh vault-init

all: claude git kitty nvim tmux vim zsh

claude:
	$(STOW) --no-folding claude

git:
	$(STOW) git

kitty:
	$(STOW) kitty

nvim:
	$(STOW) nvim

tmux:
	$(STOW) tmux

vim:
	$(STOW) vim

zsh:
	$(STOW) zsh

# Bootstrap a fresh knowledge base from the vault/ scaffold. Never overwrites an existing vault.
vault-init:
	@if [ -e $(HOME)/.vault ]; then \
		echo "~/.vault already exists — not overwriting"; \
	else \
		cp -r $(CURDIR)/vault $(HOME)/.vault && echo "bootstrapped ~/.vault from scaffold"; \
	fi
