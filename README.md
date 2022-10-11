# Dotfiles

I am figuring out how to do this stuff but here's my vim config and stuff

# Setup 
(assuming git, [scoop](https://github.com/ScoopInstaller/Scoop), and winget are installed):
```
cd $HOME
git clone --bare git@github.com:pynappo/dotwindows.git $HOME/.dotwindows.git/
git --git-dir=$HOME/.dotwindows.git/ --work-tree=$HOME checkout --force
. $PROFILE
df config status.showUntrackedFiles no
```
# Package lists: 
- [scoop.txt](.files/scoop.txt)
- [winget.txt](.files/winget.txt)

Import with:
```
scoop install $HOME/.files/scoop.csv 
winget import -i $HOME/.files/winget.txt --accept-package-agreements --accept-source-agreements
```
# Commands
|Command|Description|
|:-|:-:|
|```pacup```|It literally just runs ```scoop export``` and ```winget export``` to the aforementioned package lists.|
