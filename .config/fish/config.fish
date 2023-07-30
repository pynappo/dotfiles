if status is-interactive
    # Commands to run in interactive sessions can go here
    if set -q TERMUX_VERSION
	    fish_add_path -p "$HOME/neovim/build/bin"
    end
end

abbr -a -- dotfiles 'git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
abbr -a -- df 'git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
