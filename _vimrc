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
set laststatus=2
set list
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

" Remapping
nnoremap s <Nop>
" 分割されたウィンドウを移動する
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sw <C-w>w
" 現在のウィンドウを左下上右へ移動する
nnoremap sH <C-w>H
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
" 前後のタブへ移動する
nnoremap sn gt
nnoremap sp gT
" ウィンドウの大きさを揃える
nnoremap s= <C-w>=
nnoremap sO <C-w>=
" ウィンドウの幅、高さを増減させる
nnoremap s> <C-w>>
nnoremap s< <C-w><
nnoremap s+ <C-w>+
nnoremap s- <C-w>-
" ウィンドウを最大化する
nnoremap so <C-w>_<C-w>|
" ウィンドウを水平・垂直に分割する
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
" タブ・バッファを閉じる
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
" 新規タブ
nnoremap st :<C-u>tabnew<CR>
