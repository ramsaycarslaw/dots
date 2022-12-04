syntax on
set tabstop=2
set shiftwidth=2
set expandtab
set ai
set number
set hlsearch
set incsearch
set scrolloff=8
set ruler
set clipboard=unnamedplus,unnamed,autoselect
set backspace=indent,eol,start
set background=dark
set conceallevel=2                     " Markdow

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

" Make highlighting better
hi clear SpellBad
hi SpellBad cterm=underline,bold
hi SpellBad ctermfg=red
hi Visual ctermfg=DarkGrey
hi Visual ctermbg=LightGrey
hi Comment ctermfg=DarkBlue

