
" Commands for compiling
command Pdflatex !pdflatex %:t<CR>
command Lualatex !lualatex %:t<CR>

command Zathura !zathura *\.pdf &<CR>

function! CargoBuild() 

endfunction

" Compile and open commands

" Open stuff
if executable('zathura')
  nmap <leader>z :Zathura<CR><CR>
endif

" LaTeX
if executable('pdflatex')
  nmap <leader>Lp :Pdflatex<CR><CR>
endif
if executable('lualatex')
  nmap <leader>Ll :Lualatex<CR><CR>
endif


