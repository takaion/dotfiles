" ===============================================
" .vimrc
" ===============================================
scriptencoding utf-8

" General
let s:vim_home = expand('~/.vim/')
let s:dein_dir = s:vim_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if has('vim_starting')
  if &compatible
    set nocompatible
  endif

  if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
  endif

  let &runtimepath = s:dein_repo_dir . "," . &runtimepath
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " Plugins
  call dein#add(s:dein_repo_dir)
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  " Appearance, Colorscheme
  call dein#add('tomasr/molokai')
  call dein#add('itchyny/lightline.vim')
  " Languages/Formatting
  call dein#add('Townk/vim-autoclose')
  call dein#add('tpope/vim-endwise')
  call dein#add('vim-ruby/vim-ruby')
  call dein#add('othree/yajs.vim')
  call dein#add('othree/es.next.syntax.vim')
  call dein#add('maxmellon/vim-jsx-pretty')
  call dein#add('othree/javascript-libraries-syntax.vim')
  " Others
  call dein#add('tpope/vim-fugitive')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('sudo.vim')

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

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
if filereadable(s:dein_dir . '/repos/github.com/tomasr/molokai/colors/molokai.vim')
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
set virtualedit=onemore

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

au BufNewFile,BufRead *.json setlocal filetype=javascript
au BufNewFile,BufRead *.tex setlocal filetype=tex
au BufNewFile,BufRead *.md setlocal filetype=markdown
au FileType c,cpp setlocal cindent
au FileType sh,zsh,ruby,yaml,html,htmldjango,javascript,css setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" =====================================
" Files
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
inoremap (<Enter> ()<Left><CR><ESC><S-o>

" Shift+Tab
nnoremap <S-Tab> <<
inoremap <S-Tab> <C-d>
