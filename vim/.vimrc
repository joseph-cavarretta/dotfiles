" ------------------------------------------------------------
" CORE (must come before plugins and colorscheme)

set nocompatible
filetype plugin indent on
syntax on

" ------------------------------------------------------------
" COLORSCHEME

let g:onedark_termcolors=16
colorscheme onedark

" ------------------------------------------------------------
" PLUGINS
"
" Managed as native Vim 8 packages (git submodules under
" ~/.vim/pack/plugins/start/), auto-loaded on startup — no plugin manager.
" Install/refresh from the dotfiles repo: git submodule update --init --recursive

augroup my_tagbar_autoopen
  autocmd!
  autocmd FileType c,python call tagbar#autoopen(0)
augroup END

set laststatus=2
set statusline=%!FugitiveStatusline()

" make tagbar wider
let g:tagbar_width = 80

" ------------------------------------------------------------
" EDITOR OPTIONS

" show line numbers
set number

" highlight current line
set cursorline

" show matching brackets instantly
set showmatch

" better command-line completion
set wildmenu

" show partial commands in the last line as you type
set showcmd

" case-insensitive search unless capital letters are used
set ignorecase
set smartcase
