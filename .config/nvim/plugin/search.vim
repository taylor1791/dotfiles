" Search options and bindings

set incsearch          " Show "live" matches
set ignorecase         " Case insensitive matching
set hlsearch           " Highlight matches
set smartcase          " Respect case when using a capital letter
set inccommand=nosplit " Live preview of :substitute

" Stop highlighting matches on normal mode esc.
nnoremap <exc> :nohlsearch<cr><esc>
