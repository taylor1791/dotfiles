function link() {
  if [ ! -e "$2" ]; then
    echo "Linking $2...";
    ln -s "$1" "$2"
  fi
}

function clean_links() {
  # Kill pre-existing invalid links
  if [[ -L "$1" && ! -e "$1" ]]; then
    echo "Killing $2 invalid link..."
    rm "$1"
  fi

  # Backup existing configs
  if [[ -e "$1" && ! -h "$1" ]]; then
    echo "Backing up $2..."
    mv "$1" "$1.$(date +%s)"
  fi
}

ROOT="$(pwd)"
pushd home > /dev/null

# Files
for file in `find . -type f -maxdepth 1`; do
  file="$(basename $file)"
  full_file="${HOME}/.$(basename $file)"
  clean_links "$full_file" "$file"
  link "${ROOT}/home/$file" "$full_file"
done

# Directories
for file in `find . -type f -mindepth 2 | cut -b 3-`; do
  mkdir -p $HOME/.$(dirname $file)
  link "${ROOT}/home/$file" "$HOME/.$file"
done

popd > /dev/null
