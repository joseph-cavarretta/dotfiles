STOW := stow -t $(HOME) -R -d $(CURDIR)

.PHONY: all claude git kitty nvim tmux vim zsh

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
