oh-my-posh init fish --config '~/.files/pynappo.omp.yaml' | source
if status is-interactive
    # Commands to run in interactive sessions can go here
    if set -q TERMUX_VERSION
	    fish_add_path -p "$HOME/neovim/build/bin"
    end
end

abbr -a -- dotfiles 'git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
abbr -a -- df 'git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
abbr -a -- ldf 'lazygit --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
abbr -a -- pm 'sudo pacman'
abbr -a -- pr 'paru'
abbr -a man --set-cursor 'nvim "+Man %"'
abbr -a man --set-cursor 'nvim "+Man %"'
function last_history_item
  echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item
