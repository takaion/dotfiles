" ===============================================
" .vimrc
" ===============================================
scriptencoding utf-8

" カラースキーマの設定
colorscheme koehler
set nocompatible
syntax on
set wildmenu
set backupdir=$HOME/.vim/backup

" Display
set number
set ruler
set showcmd
set listchars=tab:▸\ ,trail:-
set scrolloff=4

" Search
set ignorecase
set smartcase
set wrapscan
set hlsearch
set history=10000

" Edit
" 新しい行のインデントを現在行と同じにする
" set autoindent
set showmatch
set autoindent
set smartindent
set cindent
set backspace=indent,eol,start
set vb t_vb=

" Tab
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set shiftround

" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

" Files
set confirm
set hidden
set autoread
set noswapfile
set nobackup

