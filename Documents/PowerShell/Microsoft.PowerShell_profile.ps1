Unblock-File $profile
Invoke-Expression (&starship init powershell)

Import-Module posh-git
Import-Module -Name Terminal-Icons

$env:POSH_GIT_ENABLED = $true

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
$ENV:STARSHIP_CONFIG = "$HOME\.files\.global\starship.toml"

Function Notepad { Notepads @Args } 
Function Dotfiles { 
	if ($Args -and ($Args[0].ToString().ToLower() -eq "link")) {
		if ($Args.Count -ne 3) {"Please supply a link path AND a link target, respectively."}
		else {
			if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
				Return Write-Error("Run as administrator please.")
			}
			if (!(Test-Path $Args[1])) { Return Write-Error("Path invalid.")}
			if (!(Test-Path $Args[2])) { Return Write-Error("Target invalid.")}
			$Path = (Resolve-Path $Args[1]).ToString()
			$Target = (Resolve-Path $Args[2]).ToString()
			
			Move-Item $Path $Target
			$Path = $Path.TrimEnd('\/')
			New-Item -ItemType SymbolicLink -Path $Path -Value ($Target + (Split-Path $Path -Leaf).ToString())
			Dotfiles add $Path
			Dotfiles add $Target
		}
	}
	else { git --git-dir=$Home/.files/ --work-tree=$HOME @Args }
}
Set-Alias -Name df -Value Dotfiles


Function Pacup ([string]$Path = "$Home\.files\"){
	scoop export > ($Path + 'scoop.txt')
	scoop bucket list | Export-Csv ($Path + 'scoopBuckets.csv')
	winget export -o ($Path + 'winget.txt') --accept-source-agreements
}

Function New-Link ($Path, $Target) {
    New-Item -ItemType SymbolicLink -Path $Path -Value $Target 
}

Function Scoop-Import { 
	<#
	.SYNOPSIS
	Imports scoop buckets and app lists.

	.DESCRIPTION
	Imports scoop buckets from a CSV made with: scoop bucket list | Export-Csv <file>.csv
	Imports scoop apps from a text file made with: scoop export > <file>.txt

	.PARAMETER  Buckets
	Specifies the file that contains the bucket list exported using: scoop bucket list | Export-Csv <file>.csv

	.PARAMETER  Apps
	Specifies the file that contains the app list exported using: scoop export > <file>.txt
	
	.EXAMPLE
	PS> scoop-import -buckets scoopBuckets.csv -apps scoop.txt

	.EXAMPLE
	PS> scoop-import scoopBuckets.csv scoop.txt

	.EXAMPLE
	PS> scoop-import -apps scoop.txt

	.LINK
	Online: https://gist.github.com/pynappo/ae3f5cf67aa2fea83dd8cc55219ef79e
	#>

	[CmdletBinding(HelpURI="https://gist.github.com/pynappo/ae3f5cf67aa2fea83dd8cc55219ef79e", PositionalBinding)]
	param ([string]$Buckets, [string]$Apps)
	if ( Test-Path $Buckets ) { Import-Csv -Path $Buckets | ForEach-Object { scoop bucket add $_.Name $_.Source } } 
	else {"No valid bucket list supplied, continuing..."}
	if ( Test-Path $Apps ) { 
		foreach ($app in Get-Content $Apps) {
			if ($app -match '(?<name>.*)\s\(.*\)\s(?:\*(?<global>.*)\*\s)?\[.*\](?:\s\{(?<arch>.*)\})?') { 
				"scoop install " + $Matches.name + ($Matches.global ? ' -g' : '') + ($Matches.arch ? ' -a ' + $Matches.arch : '') | Invoke-Expression 
			}
		}
	}
	else {Write-Error("No valid apps list supplied, ending...")}
}
