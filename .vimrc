" ===============================================
" .vimrc
" ===============================================
scriptencoding utf-8

" General
if has('vim_starting')
    if &compatible
        set nocompatible
    endif

    :call system("mkdir -p ~/.vim/{bundle,backup}")
    
    if !isdirectory(expand('~/.vim/bundle/neobundle.vim/'))
        echo "Installing NeoBundle.."
        :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
    endif
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
let g:neobundle_default_git_protocol='https'

NeoBundleFetch 'Shougo/neobundle.vim'
" Colorscheme
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'tomasr/molokai'
NeoBundle 'chriskempson/vim-tomorrow-theme'
" Plugins
NeoBundle 'Shougo/vimproc', {
    \ 'build' : {
    \     'windows' : 'make -f make_mingw32.mak',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make -f make_mac.mak',
    \     'unix' : 'make -f make_unix.mak',
    \    },
    \ }
NeoBundle 'tpope/vim-endwise', {
  \ 'autoload' : { 'insert' : 1, } }
NeoBundle 'Shougo/unite.vim/'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'Townk/vim-autoclose'
NeoBundle 'sudo.vim'

" Languages
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'othree/yajs.vim'
NeoBundle 'maxmellon/vim-jsx-pretty'
NeoBundle 'othree/javascript-libraries-syntax.vim'
NeoBundle 'othree/es.next.syntax.vim'

NeoBundleCheck
call neobundle#end()

" Plugin Settings
" vim-gitgutter
let g:gitgutter_sign_added = "+"
let g:gitgutter_sign_modified = "*"
let g:gitgutter_sign_removed = "-"

" lightline.vim
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'mode_map': {'c': 'NORMAL'},
    \ 'active': {
    \   'left': [
    \     ['mode', 'paste'],
    \     ['readonly', 'fugitive', 'gitgutter', 'filename', 'modified']
    \   ],
    \   'right': [
    \     ['lineinfo', 'syntastic'],
    \     ['percent'],
    \     ['charcode', 'fileformat', 'fileencoding', 'filetype'],
    \   ]
    \ },
    \ 'component': {
    \   'readonly': '%{&filetype=="help"?"":&readonly?"\u2b64":""}',
    \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
    \ },
    \ 'component_function': {
    \   'fugitive': 'MyFugitive'
    \ },
    \ 'component_visible_condition': {
    \   'readonly': '(&filetype!="help"&& &readonly)',
    \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))'
    \ },
    \ 'separator': { 'left': "", 'right': "" },
    \ 'subseparator': { 'left': "", 'right': "" },
    \ }

function! MyFugitive()
    if exists("*fugitive#head")
        let _ = fugitive#head()
        return strlen(_) ? "\u2b60 "._ : ''
    endif
    return ''
endfunction

" =====================================
" Display
syntax on
colorscheme koehler
if filereadable(expand('~/.vim/bundle/vim-hybrid/colors/hybrid.vim'))
    colorscheme molokai
    highlight Normal ctermbg=none
    highlight Comment ctermfg=darkgray
endif
set wildmenu
set number
set ruler
set showcmd
set laststatus=2
set list
set listchars=tab:▸\ ,trail:-
set scrolloff=4
set noshowmode
set ambiwidth=double

if &term == "screen"
    set t_Co=256
endif

" =====================================
" Search
set ignorecase
set smartcase
set wrapscan
set hlsearch
set history=10000

" =====================================
" Edit
" 新しい行のインデントを現在行と同じにする
" set autoindent
set showmatch
set autoindent
set smartindent
set cindent
set backspace=indent,eol,start
set vb t_vb=
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

" =====================================
" Tab
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set shiftround

au BufNewFile,BufRead *.rb setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.html setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.yml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
au BufNewFile,BufRead *.json setlocal filetype=javascript
au BufNewFile,BufRead *.tex setlocal filetype=tex
au BufNewFile,BufRead *.md setlocal filetype=markdown
au FileType sh setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" =====================================
" Files
set backupdir=$HOME/.vim/backup
set confirm
set hidden
set autoread
set noswapfile
set nobackup

" =====================================
" Remapping
" USキーボード向け設定
nnoremap ; :
nnoremap : ;

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

" 中括弧+Enterの設定
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>)]}
