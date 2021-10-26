# Dotfiles

I am figuring out how to do this stuff but here's my vim config and stuff

# Setup (with fish):

```
git init --bare $HOME/.files
abbr --add 'dotfiles' 'git --git-dir=$HOME/.files/ --work-tree=$HOME'
git --git-dir=$HOME/.files/ --work-tree=$HOME config --local status.showUntrackedFiles no
dotfiles config --local status.showUntrackedFiles no
```
# How to use

In fish just type dotfiles {insert git commands here}
