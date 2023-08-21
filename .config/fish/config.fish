oh-my-posh init fish --config '~/.files/pynappo.omp.yaml' | source
if status is-interactive
  # Commands to run in interactive sessions can go here
  if set -q TERMUX_VERSION
    fish_add_path -p "$HOME/neovim/build/bin"
  end
end

# make abbreviations more versatile
bind "/" expand-abbr or self-insert

abbr -a -- dotfiles 'git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
abbr -a -- .f 'git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
abbr -a -- l.f 'lazygit --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
abbr -a -- pm 'sudo pacman'
abbr -a -- pr 'paru'
abbr -a -- su 'su --shell=/usr/bin/fish'
abbr -a -- e '$EDITOR'
abbr -a -- g 'git'
abbr -a -- sudo 'sudo -E -s'
abbr -a -- edit '$EDITOR'
abbr -a nman --position anywhere --set-cursor 'nvim "+Man %"'
abbr -a .C --position anywhere '~/.config/'
abbr -a f --set-cursor 'fd . % | fzf'
function last_history_item
  echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

abbr -a -- ls "exa --icons"
abbr -a -- ll "exa --icons --group --header --group-directories-first --long"
function exa -d "exa with auto-git"
  if git rev-parse --is-inside-work-tree &>/dev/null
    command exa --git --classify $argv
  else
    command exa --classify $argv
  end
end

alias sudo="/usr/bin/sudo -v; /usr/bin/sudo"

# Created by `pipx` on 2023-08-10 08:32:24
set PATH $PATH /home/dle/.local/bin

# from nickeb96/puffer-fish
function expand_dots -d 'expand ... to ../.. etc'
  set -l cmd (commandline --cut-at-cursor)
  set -l split (string split ' ' $cmd)
  switch $split[-1]
  case './*'; commandline --insert '.'
  case '*..'
    # Only expand if the string consists of dots and slashes.
    # We don't want to expand strings like `bazel build target/...`.
    if string match --quiet --regex '^[/.]*$' $split[-1]
      commandline --insert '/..'
    else
      commandline --insert '.'
    end
  case '*'; commandline --insert '.'
  end
end
function expand_lastarg
  switch (commandline -t)
  case '!'
    commandline -t ""
    commandline -f history-token-search-backward
  case '*'
    commandline -i '$'
  end
end

set -l modes
if test "$fish_key_bindings" = fish_default_key_bindings
  set modes default insert
else
  set modes insert default
end

bind --mode $modes[1] . expand_dots
bind --mode $modes[1] '$' expand_lastarg
bind --mode $modes[2] --erase . ! '$'
