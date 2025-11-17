let g:onedark_termcolors=16
colorscheme onedark

" enable syntax highlighting
syntax on

" vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'majutsushi/tagbar'

call vundle#end()

filetype plugin indent on
autocmd FileType c call tagbar#autoopen(0)

set laststatus=2
" set statusline=%!FugitiveStatusLine()

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

" incremental search: highlight as you type
" set incsearch
" set hlsearch

" set vertical ruler
" set colorcolumn=80
" highlight ColorColumn ctermbg=darkgrey guibg=#3b4048

