" Things related to file navigation

" There is no better documentation than the source. Further teaches vim node's
" resolution algorithm allowing gf and jump right to the module's source.
Plug 'PsychoLlama/further.vim' 

" Taken from `:help last-position-jump`. Restores the cursors previous position in a
" buffer.
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
