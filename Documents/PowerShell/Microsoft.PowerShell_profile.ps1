oh-my-posh --init --shell pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/v$(oh-my-posh --version)/themes/jandedobbeleer.omp.json | Invoke-Expression
Function dotfiles { git --git-dir=$HOME/.files/ --work-tree=$HOME @Args }
Function pacup {
	winget export -o $HOME/.files/winget.txt --accept-source-agreements
	scoop export > $HOME/.files/scoop.txt
}