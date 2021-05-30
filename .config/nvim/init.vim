" The first file sourced by neovim. Eventually, plugin/* and after/plugin/*
" are too. See :help 'runtimepath' for official details. For more details on
" any options, see :help 'option-name'.

" Since <leader> is called upon by many plugin/*, elect the true leader early.
let mapleader = "\<space>"

" Install vim-plug.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl
    \ --fail
    \ --location
    \ --output ~/.config/nvim/autoload/plug.vim
    \ --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
  for file in split(glob('~/.config/nvim/config/*.vim'), '\n')
    execute 'source' file
  endfor
call plug#end()
