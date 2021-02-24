" I only really use TMUX when I have no plugins loaded
set rnu nu
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartcase
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

colorscheme peachpuff

" Make highlighting better
hi clear SpellBad
hi SpellBad cterm=underline,bold
hi SpellBad ctermfg=red

