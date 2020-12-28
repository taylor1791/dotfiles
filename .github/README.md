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

 * **bin/colors** - Displays terminal colors combinations.
 * **bin/dot** - Manages your dotfiles. It wraps `git`.
 * **bin/dotfiles** - Manages updates to dotfiles.
 * **bin/truecolor** - Manually verifies terminal true color support.
 * **bin/warn** - Echos it arguments in color to stderr

Theming
-------
Where possible, applications implement the
[OneDark](https://github.com/joshdick/onedark.vim) theme. This includes:
Alacritty, XMonad, and XMobar.
