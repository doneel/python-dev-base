set -o vi
bind '"fd":vi-movement-mode'

export HISTFILESIZE=100000
export EDITOR=vim
export SHELL=/bin/bash
export TERM=xterm-256color
export MYVIMRC = ~/.config/nvim/init.vim

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
