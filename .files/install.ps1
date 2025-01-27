# To run from new win11 install: irm https://raw.githubusercontent.com/pynappo/dotfiles/main/.files/install.ps1 | iex

function Reload-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

cd $HOME

Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
$env:Path += "$HOME\scoop\shims"
winget install Git.Git -s winget -i
winget install GitHub.cli -s winget
Reload-Path

scoop install gsudo
Reload-Path
"Disabling UAC temporarily"
gsudo cache on
gsudo {Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0}

"Setting up SSH"
Reload-Path
gsudo {
  Set-Service -StartupType Automatic -Name ssh-agent
  Start-Service ssh-agent
}
gh auth login -p ssh -h GitHub.com -w
ssh-add ~/.ssh/id_ed25519

git clone --bare https://github.com/pynappo/dotfiles.git .files.git
git clone --bare https://github.com/pynappo/dotwindows.git .windows.git
git --git-dir=$HOME/.files.git/ --work-tree=$HOME checkout --force
git --git-dir=$HOME/.windows.git/ --work-tree=$HOME checkout --force

Start-Process -FilePath 'powershell' -ArgumentList ('gsudo {scoop import $HOME\.files\scoop.json}')
winget import .\.files\winget.json --accept-source-agreements --accept-package-agreements --disable-interactivity

Reload-Path

. $PROFILE
dot config --local status.showUntrackedFiles no

"Re-enabling UAC"
gsudo {Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 1}
gsudo cache off

"Done!"
pwsh
