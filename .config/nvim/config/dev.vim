" Facilitates hacking on vim.

" Easy access to hack on init.vim
nnoremap <leader>v <esc>:vsplit ~/.config/nvim/plugin/dev.vim<cr>

" Easy sourcing
nnoremap <leader>s <esc>:source %<cr>

" Display the token under the cursor. Useful for debuggin syntax highlighting.
function dev#ShowToken()
  echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . ">"
    \ " trans<" . synIDattr(synID(line("."),col("."),0),"name") . ">"
    \ " lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunction
