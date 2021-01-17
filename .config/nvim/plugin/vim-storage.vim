if exists('$SUDO_USER')
  " Avoid creating files owned by root.
  set nobackup nowritebackup
  set noswapfile
  set noundofile
  set shada="NONE"
else
  " neovim has good defaults for undodir, backupdir, and directory.

  set undofile " Save undo to disk
  set swapfile " Enable recovery/locking - I forget all the open terminals
endif
