oh-my-posh --init --shell pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/v$(oh-my-posh --version)/themes/jandedobbeleer.omp.json | Invoke-Expression

Function dotfiles { git --git-dir=$HOME/.files/ --work-tree=$HOME @Args }
set-alias -name df -value dotfiles

Function pacup ([string]$Path = "$Home\.files\"){
	winget export -o ($Path + 'winget.txt') --accept-source-agreements
	scoop export > ($Path + 'scoop.txt')
	scoop bucket list | Export-Csv -Path ($Path + 'scoop-buckets.csv')
}

Function scoopImport { 
	Param ([string]$b)
	if ($b) { Import-Csv -Path $b | ForEach-Object { scoop bucket add $_.Name $_.Source } } 
	else {"No bucket list supplied, continuing..."}
	Param ([string]$p)
	if ($p) { gc $p | ForEach-Object { scoop install ($_ -split " ")[0] } } # -p <path to package list from scoop export> 
      else {"No package list supplied, ending..."}
}