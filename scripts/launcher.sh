#!/bin/sh
compgen -c | sort -u |fzf -m --border --color fg:#ebdbb2,bg:#1d2021,hl:#d79921,fg+:#689d6a,bg+:#282828,hl+:#fabd2f,info:#83a598,prompt:#bdae93,spinner:#b16286,pointer:#689d6a,marker:#fe8019,header:#665c54 | xargs lnch
