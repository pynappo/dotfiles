set XDG_CONFIG_HOME ~/.config
set MANPAGER 'nvim +Man!'
oh-my-posh init fish --config '~/.files/pynappo.omp.yaml' | source
if status is-interactive
  if set -q TERMUX_VERSION
    fish_add_path -p "$HOME/neovim/build/bin"
  end
  export (systemctl show-environment --user)
  # Emulates vim's cursor shape behavior
  # Set the normal and visual mode cursors to a block
  set fish_cursor_default block
  # Set the insert mode cursor to a line
  set fish_cursor_insert line
  # Set the replace mode cursor to an underscore
  set fish_cursor_replace_one underscore
  # The following variable can be used to configure cursor shape in
  # visual mode, but due to fish_cursor_default, is redundant here
  set fish_cursor_visual block
  set fish_vi_force_cursor 1
  set LS_COLORS $(vivid generate ayu)
end

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

function fish_user_key_bindings
  # Execute this once perk mode that emacs bindings should be used in
  fish_default_key_bindings -M insert

  # Then execute the vi-bindings so they take precedence when there's a conflict.
  # Without --no-erase fish_vi_key_bindings will default to
  # resetting all bindings.
  # The argument specifies the initial mode (insert, "default" or visual).
  fish_vi_key_bindings --no-erase insert
  # make abbreviations more versatile
  bind -M insert / expand-abbr or self-insert
  bind --mode insert . expand_dots
  bind --mode insert '$' expand_lastarg
  # fzf_user_key_bindings
end

# see ./conf.d/abbr_helpers.fish
abbr -a -- dotfiles 'git --git-dir=$HOME/.files.git/ --work-tree=$HOME'
abbr -a -- dot 'git --git-dir=$HOME/.files.git/ --work-tree=$HOME'
abbr -a -- ldot 'lazygit --git-dir=$HOME/.files.git/ --work-tree=$HOME'
abbr -a -- pm 'sudo pacman'
abbr -a -- su 'su --shell=/usr/bin/fish'
abbr -a -- e '$EDITOR'
abbr -a -- g 'git'
abbr_subcommand git co checkout
abbr_subcommand git ch cherry-pick
abbr_subcommand git c commit
abbr_subcommand git a add
abbr -a -- sudo 'sudo -E -s'
abbr -a -- sc 'systemctl'
abbr -a --position anywhere --set-cursor nman 'nvim "+Man %"'
abbr -a --position anywhere .C "$XDG_CONFIG_HOME/"
abbr -a --set-cursor f 'fd . % | fzf'
abbr -a -- jammers 'mpv "https://www.youtube.com/playlist?list=PLg-SQpG3Qf59d1hzWtxsFqZt9n0e2llep" --no-video --no-resume-playback'
abbr -a -- ocr 'grim -g "$(slurp)" - | tesseract - - | wl-copy'
abbr -a -- wlsudo 'socat UNIX-LISTEN:/tmp/.X11-unix/X1 UNIX-CONNECT:/tmp/.X11-unix/X0 & sudo DISPLAY=:1'
abbr -a --set-cursor ibmconnect 'IBM_USER="%" begin; echo (secret-tool lookup ibmconnect $IBM_USER) | sudo openconnect https://vpnisv.isv.ihost.com --authgroup Anyconnect -u sjsustudent6 --passwd-on-stdin; end'
abbr -a --set-cursor :h 'nvim "+help %"'
abbr -a -- pacup 'sudo pacman -Qqen > ~/.files/pacman.txt && sudo pacman -Qqen > ~/.files/paru.txt'
abbr -a -- pr 'paru'
abbr -a -- - 'prevd'
abbr -a -- + 'nextd'

abbr -a -- pacsearch 'pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S'
abbr -a -- pacremove 'pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns'
function edit
    echo $EDITOR $argv
end
# abbr -a edit_texts --position command --regex ".+\.txt" --function edit


function last_history_item
  echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

abbr -a -- ls "eza --icons"
abbr -a -- ll "eza --icons --group --header --group-directories-first --long"
function eza -d "eza with auto-git"
  if git rev-parse --is-inside-work-tree &>/dev/null
    command eza --git --classify $argv
  else
    command eza --classify $argv
  end
end
# refresh sudo timeout
alias sudo="/usr/bin/sudo -v; /usr/bin/sudo"
