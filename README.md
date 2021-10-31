# Dotfiles

I am figuring out how to do this stuff but here's my vim config and stuff

# Setup:

```
echo ".files.git" >> .gitignore
git clone --bare https://www.github.com/pynappo/dotfiles.git $HOME/.files
git --git-dir=$HOME/.files/ --work-tree=$HOME checkout
git --git-dir=$HOME/.files/ --work-tree=$HOME config --local status.showUntrackedFiles no
```

To more easily manage the dotfile repository add:

```
abbr -a dotfiles 'git --git-dir=$HOME/.files/ --work-tree=$HOME'
```

# Features

**Fish abbreviations that are cool**

```
jammers => 'youtube-viewer :playlist=PLg-SQpG3Qf59d1hzWtxsFqZt9n0e2llep -s -A -a --append-arg="--volume=40"'
pm => doas pacman
pr => paru
pacup => pacman -Qqen > .files/paclist.txt && pacman -Qqem > .files/aurlist.txt
```

