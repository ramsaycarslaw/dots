
if ($TERM_PROGRAM == "iTerm.app")
	source ~/.vim/rice.vim
else
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
	set smartindent
	set expandtab
	set noerrorbells
  set nocompatible

	syntax on

  " Make highlighting better
  hi clear SpellBad
  hi SpellBad cterm=underline,bold
  hi SpellBad ctermfg=red

  " Move around windows with SPC-h,j,k,l
  nnoremap <leader>h :wincmd h<CR>
  nnoremap <leader>j :wincmd j<CR>
  nnoremap <leader>k :wincmd k<CR>
  nnoremap <leader>l :wincmd l<CR>
endif
