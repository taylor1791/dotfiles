# Install better font

if ! xcode-select -p > /dev/null; then
  echo "Installing XCode Command Line Tools..."
  xcode-select -–install
fi

if ! type "ag" > /dev/null; then
  echo "Installing the super searcher, The Silver Searcher..."
  brew install the_silver_searcher
fi

if ! type "asciinema" > /dev/null; then
  echo "Installing asciinema, the terminal sessions recorder..."
  brew install asciinema
fi

if [ ! -f /usr/local/bin/nvim ]; then
  echo "Installing neovim..."
  brew install neovim
fi

if [ ! -f ~/.vim/autoload/plug.vim ]; then
  echo "Installing vim Plugin Manager..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if ! type "direnv" > /dev/null; then
  echo "Installing direnv..."
  brew install direnv
fi
