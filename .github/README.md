dotfiles
========
A [bare](https://www.atlassian.com/git/tutorials/dotfiles) dotfiles repo. If you
can't figure out what that means, you are probably in over your head.

Setup
-----
Ensure `awk`, `curl`, and  `git` are available, then run the following:

```bash
curl https://raw.githubusercontent.com/taylor1791/dotfiles/master/bin/dot | bash`
```

Usage
-----
These dotfiles come with a few things.

 * **bin/bopen** - `xdg-open`s lists and trickles.
 * **bin/colors** - Displays terminal colors combinations.
 * **bin/daily** - Opens daily tasks.
 * **bin/dot** - Manages dotfiles. It wraps `git`.
 * **bin/dotfiles** - Manages updates to dotfiles.
 * **bin/totp** - Encrypted TOTP authenticator.
 * **bin/truecolor** - Manually verifies terminal true color support.
 * **bin/warn** - Echos it arguments in color to stderr

Theming
-------
Where possible, applications implement the
[OneDark](https://github.com/joshdick/onedark.vim) theme. This includes:
Alacritty, neovim, rofi, XMonad, XMobar, and zathura.
