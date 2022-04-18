oh-my-posh init pwsh --config $Home/.files/.global/pynappo.omp.json | Invoke-Expression
Enable-PoshTooltips
Enable-PoshLineError

Import-Module posh-git
$env:POSH_GIT_ENABLED = $true

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

Function notepad { notepads @Args } 
Function Dotfiles { git --git-dir=$Home/.files/ --work-tree=$HOME @Args }
set-alias -name df -value dotfiles


Function Pacup ([string]$Path = "$Home\.files\"){
	winget export -o ($Path + 'winget.txt') --accept-source-agreements
	scoop export > ($Path + 'scoop.txt')
	scoop bucket list | Export-Csv -Path ($Path + 'scoop-buckets.csv')
}

Function ScoopImport { 
	Param ([string]$Buckets)
	if ($Buckets) { Import-Csv -Path $Buckets | ForEach-Object { scoop bucket add $_.Name $_.Source } } 
	else {"No bucket list supplied, continuing..."}
	Param ([string]$Apps)
	if ($Apps) { Get-Content $Apps | ForEach-Object { scoop install ($_ -split " ")[0] } }
    else {"No apps list supplied, ending..."}
}