#!/usr/bin/env bash
# ensure you set the executable bit on the file with `chmod u+x install.sh`

# If you remove the .example extension from the file, once your workspace is created and the contents of this
# repo are copied into it, this script will execute.  This will happen in place of the default behavior of the workspace system,
# which is to symlink the dotfiles copied from this repo to the home directory in the workspace.
#
# Why would one use this file in stead of relying upon the default behavior?
#
# Using this file gives you a bit more control over what happens.
# If you want to do something complex in your workspace setup, you can do that here.
# Also, you can use this file to automatically install a certain tool in your workspace, such as vim.
#
# Just in case you still want the default behavior of symlinking the dotfiles to the root,
# we've included a block of code below for your convenience that does just that.

set -euo pipefail

DOTFILES_PATH="$HOME/dotfiles"

# Symlink dotfiles to the root within your workspace
find $DOTFILES_PATH -type f -path "$DOTFILES_PATH/.*" |
while read df; do
  link=${df/$DOTFILES_PATH/$HOME}
  mkdir -p "$(dirname "$link")"
  ln -sf "$df" "$link"
done

# ---------- Homebrew (Linuxbrew) install ----------

# Install Homebrew non-interactively to the default Linux path
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Make brew available in this script (Linuxbrew default prefix)
if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  echo "Homebrew install directory not found at /home/linuxbrew/.linuxbrew" >&2
  echo "Check the installer output to see where it was installed." >&2
  exit 1
fi

# ---------- Packages you want ----------

brew install withgraphite/tap/graphite