# dotwindows

This is a set of dotfiles for my Windows machines. It's a bare repo stored in $HOME (C:/Users/{insert name here}) that is managed through the powershell alias/function ```dotfiles``` (in the [powershell profile](Documents/PowerShell/Microsoft.PowerShell_profile.ps1)).

# Setup 
(assuming git, [scoop](https://github.com/ScoopInstaller/Scoop), and winget are installed):
```
cd $HOME
git clone

```
# Package lists: 
- [scoop.txt](.files/scoop.txt)
- [winget.txt](.files/winget.txt)

Import with:
```
scoop install $HOME/.files/scoop.txt 
winget import -i $HOME/.files/winget.txt --accept-package-agreements --accept-source-agreements
```
# Commands
|Command|Description|
|:-|:-:|
|```pacup```|It literally just runs ```scoop export``` and ```winget export``` to the aforementioned package lists.|
