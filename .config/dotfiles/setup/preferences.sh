#!/usr/bin/env bash
set -e

PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')

if [[ "${PLATFORM}" == "darwin" ]]; then
  # IMPORTANT: Big Sur might have broke some of these.
  # There is a bunch of things missing here, see the following for more
  # possibilities. https://github.com/mathiasbynens/dotfiles/blob/main/.macos

  # Tracking down the physical location of these settings is not easy. Many are
  # stored somewhere in ~/Library/Preferences/. When in doubt, manually
  # changing the setting in the UI and diffing may help. These command may
  # simplify your investigation.
  #
  # Locate recently changed preferences
  # find ~/Library/Preferences -type f -exec stat -f '%m %N' "{}" \; | sort --reverse | head
  #
  # Covert plist into xml
  # plutil -convert xml1 file.plist
  #
  #   defaults read .GlobalPreferences
  #   defaults -currentHost read .GlobalPreferences
  #   defaults read

  # Human Input Devices - Only apply after logout/login
  defaults write .GlobalPreferences com.apple.trackpad.scaling 0.9375
  defaults write .GlobalPreferences KeyRepeat -int 2
  defaults write .GlobalPreferences InitialKeyRepeat -int 15
  defaults write com.apple.touchbar.agent PresentationModeGlobal functionKeys

  # Finder: show all filename extensions
  defaults write .GlobalPreferences AppleShowAllExtensions -bool true
fi
