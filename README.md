# Dotfiles

I am figuring out how to do this stuff but here's my vim config and stuff

# Setup (with fish):

```
echo ".files.git" >> .gitignore
git clone --bare https://www.github.com/pynappo/dotfiles.git $HOME/.files
git --git-dir=$HOME/.files/ --work-tree=$HOME checkout
git --git-dir=$HOME/.files/ --work-tree=$HOME config --local status.showUntrackedFiles no
```

To more easily manage the dotfile repository add:

```
abbr -r 'git --git-dir=$HOME/.files/ --work-tree=$HOME'
```
