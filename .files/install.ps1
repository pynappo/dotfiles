# To run from new win11 install: irm https://raw.githubusercontent.com/pynappo/dotfiles/main/.files/install.ps1 | iex

function Reload-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

cd $HOME

Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
winget install Git.Git -i
Reload-Path

scoop install gsudo
Reload-Path
"Disabling UAC temporarily"
gsudo cache on
gsudo Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

"Setting up SSH"
gsudo {Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0}
gsudo {Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0}
Reload-Path
Set-Service -StartupType Automatic -Name ssh-agent
Start-Service ssh-agent
$EMAIL = Read-Host "Input email for ssh"
$SSH_PASSPHRASE = Read-Host "Input passphrase for ssh"
mkdir .ssh
ssh-keygen -t ed25519 -f .\.ssh\id_ed25519 -C ($EMAIL) -p ($SSH_PASSPHRASE)

"Send ssh key to github"
gh auth login
gc .\.ssh\id_ed25519.pub | clip
"Copied public key to clipboard, opening GitHub for you to paste it as a signing key"
[System.Diagnostics.Process]::Start("msedge","https://github.com/settings/ssh/new")
"SSH done"

git clone --bare https://github.com/pynappo/dotfiles.git .dotfiles.git
git clone --bare https://github.com/pynappo/dotwindows.git .dotwindows.git
git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout --force
git --git-dir=$HOME/.dotwindows.git/ --work-tree=$HOME checkout --force

Start-Process -FileName 'powershell' -ArgumentList ("gsudo", '{scoop import .\.files\scoop.json}')
winget import .\.files\winget.json

Reload-Path

. $PROFILE
df config --local status.showUntrackedFiles no

"Removing notepad"
winget uninstall 9MSMLRH6LZF3
gsudo {Remove-WindowsCapability -Online -Name Microsoft.Windows.Notepad.System~~~~0.0.1.0}

"Re-enabling UAC"
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 1
gsudo cache off

"Done!"
pwsh
