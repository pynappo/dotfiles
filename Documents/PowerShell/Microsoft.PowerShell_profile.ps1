oh-my-posh --init --shell pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/v$(oh-my-posh --version)/themes/jandedobbeleer.omp.json | Invoke-Expression
Function dotfiles { git --git-dir=$HOME/.files/ --work-tree=$HOME @Args }
set-alias -name df -value dotfiles

Function pacup {
	winget export -o $Home/.files/winget.txt --accept-source-agreements
	scoop export > $Home/.files/scoop.txt
	scoop bucket list | Export-Csv -Path $Home\.files\scoop-buckets.csv
}
Function scoopImportBuckets { Import-Csv -Path @Args | ForEach-Object{ scoop bucket add $_.Name $_.Source } }
Function scoopImport { gc @Args | ForEach-Object { scoop install ($_ -split " ")[0] } }