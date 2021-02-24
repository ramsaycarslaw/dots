set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

syntax on

set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nu rnu
set smartcase
set noswapfile
set hidden
set nobackup
set nowritebackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set backspace=2
set updatetime=300
set scrolloff=8
set pumheight=10
set mouse=a
set encoding=UTF-8
set clipboard+=unnamedplus

" Only iTerm supports these colors so we check
if ($TERM_PROGRAM == "iTerm.app")
  set termguicolors
  set cursorline
endif

filetype plugin on

call plug#begin('~/.vim/plugged')
" Language support
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'
Plug 'lervag/vimtex'

" Editor enhancements
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Note taking & md
Plug 'vimwiki/vimwiki'
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}

" Lsp Stuff
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'

" Tree sitter stuff
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Nerd Tree
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

" Visual
Plug 'arzg/vim-colors-xcode'
Plug 'itchyny/lightline.vim'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'chrisbra/Colorizer'
call plug#end()

filetype plugin indent on

set background=dark

" iTerm is riced, terminal is not
colorscheme xcodedark
set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'OldHope',
      \ }

" italic comments
if !exists("$TMUX")
  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
  hi Comment cterm=italic
endif

" Make highlighting better
hi clear SpellBad
hi SpellBad cterm=underline,bold
hi SpellBad ctermfg=red

" Fix tmux
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"


" let the cursor change on mode 
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

let mapleader = " "
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25

" LaTeX settings
let g:tex_flavor = 'lualatex'

if has("autocmd")
    augroup templates
        autocmd BufNewFile *.tex 0r ~/.vim/templates/skeleton.tex
    augroup END
endif

" Move around windows with SPC-h,j,k,l
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>v :wincmd v<CR>

" Split with 2 and 3 like emacs
nnoremap <leader>2 :sp<CR>
nnoremap <leader>3 :vsp<CR>
nnoremap <leader>_ :wincmd _<CR>

" I find $ and 0 too clunky
nmap L $
nmap H 0

" Resize windows with ctrl hjkl
nnoremap <C-j> :resize -2<CR>
nnoremap <C-k> :resize +2<CR>
nnoremap <C-h> :vertical resize -2<CR>
nnoremap <C-l> :vertical resize +2<CR>

" hahah nerd
nnoremap <leader>n :NERDTreeToggle<CR>

" Go stuff
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

" Rust
let g:rustfmt_autosave = 1

" Finding stuff using fzf
nnoremap <leader>f :Files<CR>
nnoremap <leader>s :BLines<CR>
nnoremap <leader>w :Windows<CR>
nnoremap <leader>b :Buffers<CR>

" Font size in firenvim is horrid 
if exists('g:started_by_firenvim') && g:started_by_firenvim
  set guifont=monspace:h14
endif


" Tree shitter

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
EOF


lua << EOF
local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Rust
nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importMergeBehavior = "last",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})

require'lspconfig'.gopls.setup{on_attach=on_attach}
require'lspconfig'.ccls.setup{on_attach=on_attach}

EOF

set completeopt=menuone,noinsert,noselect
let g:completion_matching_stratergy_list = ['exact', 'substring', 'fuzzy']

nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.declaration()<CR>
