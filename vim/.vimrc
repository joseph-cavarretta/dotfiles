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
Plugin 'tpope/vim-fugitive'

call vundle#end()

filetype plugin indent on

augroup my_tagbar_autoopen
  autocmd!
  autocmd FileType c,python call tagbar#autoopen(0)
augroup END


set laststatus=2
set statusline=%!FugitiveStatusline()

" make tagbar wider
let g:tagbar_width = 80

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

