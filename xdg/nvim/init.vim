call plug#begin('~/.vim/plugged')
  " Themes
  Plug '~/.config/nvim/my-vim'

  " Usability
  Plug 'editorconfig/editorconfig-vim' " Change config based on project
  Plug 'vim-scripts/gitignore' " Do not autocomplete files in gitignore
  Plug 'troydm/zoomwintab.vim' " Maxmize a buffer
  Plug 'MarcWeber/vim-addon-local-vimrc' " local vimrc
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " Load nerd tree whn

  " Coding
  Plug 'w0rp/ale' " Asynchronous Lint Engine
  let g:ale_maximum_file_size = '500000'

  " Languages
  Plug 'PsychoLlama/further.vim' " Better file resolution for js
  Plug 'raichoo/purescript-vim' " PureScript Syntax Highlighting
  Plug 'rust-lang/rust.vim' " Rust Syntax Highlighting

  " Fun
  Plug 'mmisono/viminesweeper', { 'on': 'MineSweeper' }

  " Plug 'tpope/vim-fugitive'
  " Plug 'int3/vim-extradite'
  " Plug 'Raimondi/delimitMate'
  " Plug 'tpope/vim-surround'

  " Elm
  " Plug 'elmcast/elm-vim'

  " Haskell
  " Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
  " Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
  " Plug 'nbouscal/vim-stylish-haskell', { 'for': 'haskell' }
  " Plug 'eagletmt/ghcmod-vim', { 'for': 'haskell' }
  " Plug 'bitc/vim-hdevtools'

  " " Plugged Reference
  " " Group dependencies, vim-snippets depends on ultisnips
  " Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  "
  " " On-demand loading
  " Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  " Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
  "
  " " Using git URL
  " Plug 'https://github.com/junegunn/vim-github-dashboard.git'
  "
  " " Plugin options
  " Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
  "
  " " Plugin outside ~/.vim/plugged with post-update hook
  " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
  "
  " " Unmanaged plugin (manually installed and updated)
  " Plug '~/my-prototype-plugin'
call plug#end()

" This is my fancy autocomplete written by the psychollama
function! s:check_back_space() abort
  let l:col = col('.') - 1
  return !l:col || getline('.')[l:col - 1]  =~? '\s'
endfunction

function! s:tab_completion(shifting) abort
  if pumvisible()
    if a:shifting
      return "\<C-p>"
    endif

    return "\<C-n>"
  elseif s:check_back_space()
    return "\<TAB>"
  else
    return "\<C-n>"
  endif
endfunction

inoremap <silent><expr><TAB> <SID>tab_completion(0)
inoremap <silent><expr><S-TAB> <SID>tab_completion(1)




filetype off
filetype plugin indent on

set nocompatible
set modelines=0
set background=dark

set t_Co=256
colorscheme ThemerNightSky
"Adjust signscolumn and wombat
hi! link SignColumn LineNr

" Use pleasant but very visible search hilighting
hi! link Visual Search

hi clear Conceal " Use same color behind concealed unicode characters

set title
set nowrap
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=4
set expandtab

set fileencoding=utf8
set scrolloff=7
set autoindent
set smartindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set laststatus=2
set relativenumber " Use relative line numbers
set number         " Except for the current line
set undofile

set mouse=a
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
set magic

set list
set lazyredraw
set viminfo^=%

syntax on

set wildignore+=*/tmp/*,*.sp,*.swp,*.zip,*node_modules*
highlight TrailingSpace guibg=red ctermbg=red
match TrailingSpace /\s\+$/

set smartindent
set cindent

" Extra file location
set backup
set backupcopy=yes
set undodir=~/.config/nvim/.undo
set backupdir=~/.config/nvim/.backup
set directory=~/.config/nvim/.swap

" This makes OSX clipboard work as expected
" set clipboard=unnamed
set clipboard+=unnamedplus

if has("nvim")
  :tnoremap <Esc> <C-\><C-n> " Let Esc leave terminal
  autocmd TermOpen * setlocal nonumber norelativenumber " Turn off line numbers in terminal
endif

" REPL Like things
function! REPLSend(lines)
  call jobsend(g:last_terminal_job_id, add(a:lines, ''))
endfunction

command! REPLSendLine call REPLSend([getline('.')])
" TODO Send Selection

" Haskell
let g:syntastic_haskell_hdevtools_args = '-g -Wall -g -fno-code'

" function! Pointfree()
"   call setline('.', split(system('pointfree '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
" endfunction
" 
" function! Pointful()
"   call setline('.', split(system('pointful '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
" endfunction

" nnoremap <silent> <leader>hh :Hoogle<CR> " Hoogle the word under the cursor
" nnoremap <leader>hH :Hoogle " Hoogle and prompt for input
" nnoremap <silent> <leader>hi :HoogleInfo<CR> " Hoogle for detailed documentation (e.g. "Functor")
" nnoremap <leader>hI :HoogleInfo " Hoogle for detailed documentation and prompt for input
" nnoremap <silent> <leader>hz :HoogleClose<CR> " Hoogle, close the Hoogle window

" nnoremap <silent> <leader>ht :GhcModType<CR>
" nnoremap <silent> <leader>hT :GhcModTypeInsert<CR>
" nnoremap <silent> <leader>h<CR> :GhcModTypeClear<CR>

" vnoremap <silent> <leader>h. :call Pointfree()<CR>
" vnoremap <silent> <leader>h, :call Pointful()<CR>

" Configure keybindings
nnoremap Q <nop> " Kill the damned Ex mode.
nnoremap <silent> <leader>rl :REPLSendLine<CR>

" Help Mr. Pinkie
nnoremap ; :

" Treat long lines as break lines
nnoremap j gj
nnoremap k gk

let mapleader = " "

" Source the vimrc file after saving it
augroup sourcing
  autocmd!
  autocmd bufwritepost init.vim source $MYVIMRC
augroup END

" Automaticall lint haskel files on save
" augroup lint
"   autocmd!
"   autocmd bufwritepost *.hs :GhcModCheckAndLintAsync
" augroup END

" Return to last edit position when opening files
augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END

augroup Terminal
  au!
  au TermOpen * let g:last_terminal_job_id = b:terminal_job_id
augroup END

