" vimrc config 
set rnu nu
set tabstop=2
set shiftwidth=2
set softtabstop=2
set ic
set hidden
set nobackup
set noswapfile
set nowritebackup
set incsearch
set hlsearch
set scrolloff=8
set clipboard=unnamedplus,unnamed,autoselect
set updatetime=300
set mouse=a
set pumheight=10
set smartindent
set expandtab
set noerrorbells
set nocompatible
set nowrap
set backspace=indent,eol,start
set ruler

syntax on
filetype plugin indent on

let mapleader=" "

" Move around windows with SPC-h,j,k,l
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

" Escape can also be a pain sometimes
imap jj <Esc>
imap kk <Esc>

" I find $ to be a bit too awkward
nmap L $
nmap H 0
vmap L $
vmap H 0

" Arrow keys are relative lines
nmap <Up> gk
nmap <Down> gj

vmap <Down> gj
vmap <Down> gj

colorscheme peachpuff

" Make highlighting better
hi clear SpellBad
hi SpellBad cterm=underline,bold
hi SpellBad ctermfg=red
hi Visual ctermbg=DarkBlue 
hi Visual ctermfg=White
highlight Comment cterm=italic gui=italic

" You have to enter these charecters with C-v Esc
set t_ZH=[3m
set t_ZR=[23m
