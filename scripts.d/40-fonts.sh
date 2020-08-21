PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')

if [[ "${PLATFORM}" == "darwin" ]]; then
  FONT_DIRECTORY=""$HOME/Library/fonts
else
  FONT_DIRECTORY="$HOME/.fonts"
fi

for f in `find fonts/ -name '*.ttf'`; do
  if [[ ! -f "$FONT_DIRECTORY/$(basename $f)" ]]; then
    echo Installing $(basename "$f")
    cp "$f" "$FONT_DIRECTORY"
  fi
done
