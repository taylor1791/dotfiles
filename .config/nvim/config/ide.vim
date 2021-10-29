" Someday I will internalize hex colors, until then...
Plug 'chrisbra/Colorizer'
let g:colorizer_auto_filetype='css,html,js'

" Fuzzy finder
Plug 'lotabout/skim'
Plug 'lotabout/skim.vim'
nnoremap <leader>f <esc>:Files!<cr>
nnoremap <leader>/ <esc>:Rg<cr>

" Test and source file swapping
Plug 'PsychoLlama/alternaut.vim'
let alternaut#conventions = {}
let alternaut#conventions['javascript'] = {
  \   'directory_naming_conventions': ['__tests__', 'tests'],
  \   'file_naming_conventions': ['{name}.test.{ext}', '{name}.spec.{ext}'],
  \   'file_extensions': ['js', 'jsx'],
  \ }
nmap <leader>t <Plug>(alternaut-toggle)

" Linting engines
Plug 'w0rp/ale'
let g:ale_fix_on_save = v:true
