# Dotfiles

I am figuring out how to do this stuff but here's my vim config and stuff

# Setup (with fish):

```
echo ".files.git" >> .gitignore
git clone --bare https://www.github.com/pynappo/dotfiles.git $HOME/.files
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```
# How to use

In fish just type dotfiles {insert git commands here}
