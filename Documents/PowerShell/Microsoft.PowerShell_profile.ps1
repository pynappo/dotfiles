Unblock-File $profile
oh-my-posh init pwsh --config $Home/.files/.global/pynappo.omp.json | Invoke-Expression
Enable-PoshTooltips
Enable-PoshLineError

Import-Module posh-git
$env:POSH_GIT_ENABLED = $true

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

Function Notepad { 
	
} 
Function Dotfiles { 
	if ($Args.Count -gt 2 -and $Args[0].ToString().ToLower() -eq "link") {
		Move-Item -Path $Args[1] -Destination $Args[2]
		New-Item -ItemType SymbolicLink -Path $Args[2] -Value $Args[1]
	}
	else { git --git-dir=$Home/.files/ --work-tree=$HOME @Args }
}
Set-Alias -Name df -Value Dotfiles


Function Pacup ([string]$Path = "$Home\.files\"){
	scoop export > ($Path + 'scoop.txt')
	scoop bucket list | Export-Csv ($Path + 'scoopBuckets.csv')
	winget export -o ($Path + 'winget.txt') --accept-source-agreements
}

Function New-Link ($link, $target) {
    New-Item -ItemType SymbolicLink -Path $link -Value $target 
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
	param (
		[string]
		$Buckets,
		[string]
		$Apps
	)
	if ( Test-Path $Buckets ) { Import-Csv -Path $Buckets | ForEach-Object { scoop bucket add $_.Name $_.Source } } 
	else {"No valid bucket list supplied, continuing..."}
	if ( Test-Path $Apps ) { 
		foreach ($app in Get-Content $Apps) {
			if ($app -match '(?<name>.*)\s\(.*\)\s(?:\*(?<global>.*)\*\s)?\[.*\](?:\s\{(?<arch>.*)\})?') { 
				"scoop install " + $Matches.name + ($Matches.global ? ' -g' : '') + ($Matches.arch ? ' -a ' + $Matches.arch : '') | Invoke-Expression 
			}
		}
	}
	else {"No valid apps list supplied, ending..."}
}