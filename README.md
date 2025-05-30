A set of dotfiles containing most of my Linux and Windows dotfiles. For Windows-exclusive dotfiles, see [dotwindows](https://github.com/pynappo/dotwindows).

# Setup

## Windows

(assuming git, [scoop](https://github.com/ScoopInstaller/Scoop), and winget are installed):

## Powershell

See [.files/install.ps1](./.files/scoop.json)

TK

## Arch

```
cd $HOME
git clone --bare git@github.com:pynappo/dotfiles.git $HOME/.files.git/
git --git-dir=$HOME/.files.git/ --work-tree=$HOME checkout --force
. $PROFILE
dot config status.showUntrackedFiles no
```

# Package lists:
## Windows
- [scoop.json](.files/scoop.json)
- [winget.json](.files/winget.json)

Import with:
```
scoop install $HOME/.files/scoop.csv
winget import -i $HOME/.files/winget.txt --accept-package-agreements --accept-source-agreements
```
# Commands
|Command|Description|
|:-|:-:|
|```pacup```|It literally just runs ```scoop export``` and ```winget export``` to the aforementioned package lists.|
