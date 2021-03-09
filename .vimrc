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
set backspace=indent,eol,start
set ruler
set path+=**
set wildmenu
" File tree
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split = 2
let g:netrw_winsize = 25

syntax on
filetype plugin indent on

let mapleader=" "
" Move around windows with SPC-h,j,k,l
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>\ :wincmd v<CR>
nnoremap <leader>- :wincmd s<CR>
nnoremap <C-j> :resize +2<CR>
nnoremap <C-k> :resize -2<CR>
nnoremap <C-h> :vertical resize +2<CR>
nnoremap <C-l> :vertical resize -2<CR>

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

nmap <leader>n :Lex<CR>

colorscheme peachpuff

" Make highlighting better
hi clear SpellBad
hi SpellBad cterm=underline,bold
hi SpellBad ctermfg=red
hi Visual ctermbg=DarkBlue 
hi Visual ctermfg=White
highlight Comment cterm=italic gui=italic
hi VertSplit cterm=NONE

" You have to enter these charecters with C-v Esc
set t_ZH=[3m
set t_ZR=[23m

" Word count for LateX
autocmd FileType tex map <leader>w :w !detex \| wc -w<CR>

" brew install choose-gui
function! ChooseFile()
  let selection = system("ls -a | choose")
  if len(selection) == 0 
    return
  endif
  exec ":e " . selection
endfunction

function! SearchFile()
  let selection = system('cat -n .vimrc | choose') 
  if len(selection) == 0 
    return
  endif
  let splits = split(selection)
  exec ":" . splits[0]
endfunction

" shortcut
if executable('choose')
  nnoremap <leader>f :call ChooseFile()<cr>
  nnoremap <leader>s :call SearchFile()<cr>
endif

source ~/.vim/compile.vim
