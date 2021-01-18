" Fuzzy finder
Plug 'lotabout/skim'
Plug 'lotabout/skim.vim'
nnoremap <leader>f <esc>:Files!<cr>

" Test and source file swapping
Plug 'PsychoLlama/alternaut.vim'
let alternaut#conventions = {}
let alternaut#conventions['javascript'] = {
  \   'directory_naming_conventions': ['__tests__', 'tests'],
  \   'file_naming_conventions': ['{name}.test.{ext}', '{name}.spec.{ext}'],
  \   'file_extensions': ['js', 'jsx'],
  \ }
nmap <leader>t <Plug>(alternaut-toggle)
