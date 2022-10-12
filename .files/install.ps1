function Reload-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

cd $HOME

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

Reload-Path

scoop install gsudo
"Disabling UAC temporarily"
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0


"Setting up SSH"
Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
winget install Microsoft.OpenSSH.Beta --override ADDLOCAL=Client
gsudo [Environment]::SetEnvironmentVariable("Path", $env:Path + ';' + ${Env:ProgramFiles} + '\OpenSSH', [System.EnvironmentVariableTarget]::Machine)
gsudo Set-Service -StartupType Automatic
Start-Service ssh-agent
"SSH done"

git clone --bare https://github.com/pynappo/dotwindows.git .dotwindows.git
git clone --bare https://github.com/pynappo/dotfiles.git .dotfiles.git

Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0


pwsh
