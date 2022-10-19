# To run from new win11 install: irm https://raw.githubusercontent.com/pynappo/dotfiles/main/.files/install.ps1 | iex

function Reload-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

cd $HOME

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

Reload-Path

scoop install gsudo
Reload-Path
"Disabling UAC temporarily"
gsudo Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

"Setting up SSH"
gsudo {Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0}
winget install Microsoft.OpenSSH.Beta --override ADDLOCAL=Client
gsudo {[Environment]::SetEnvironmentVariable("Path", $env:Path + ';' + ${Env:ProgramFiles} + '\OpenSSH', [System.EnvironmentVariableTarget]::Machine)
Get-Service
Set-Service -StartupType Automatic -Name ssh-agent
Start-Service ssh-agent}
"SSH done"

git clone --bare https://github.com/pynappo/dotfiles.git .dotfiles.git
git clone --bare https://github.com/pynappo/dotwindows.git .dotwindows.git

git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME checkout --force
git --git-dir=$HOME/.dotwindows.git/ --work-tree=$HOME checkout --force

scoop import .\.files\scoop.json
winget import .\.files\winget.json

Reload-Path

. $PROFILE

"Removing notepad"
winget uninstall 9MSMLRH6LZF3
gsudo {Remove-WindowsCapability -Online -Name Microsoft.Windows.Notepad.System~~~~0.0.1.0}

"Re-enabling UAC"
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 1

pwsh
