if set -q TERMUX_VERSION
  fish_add_path -g "$HOME/neovim/build/bin"
end
if type -q systemctl
  for var in (systemctl show-environment --user | rg -v '^PATH=')
    export $var
  end
end
if test -d /home/linuxbrew/.linuxbrew # Linux
	set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
	set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
	set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"
else if test -d /opt/homebrew # MacOS
	set -gx HOMEBREW_PREFIX "/opt/homebrew"
	set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
	set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/homebrew"
end
if set -q HOMEBREW_PREFIX
  fish_add_path -g "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin";
  ! set -q MANPATH; and set MANPATH ''; set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH;
  ! set -q INFOPATH; and set INFOPATH ''; set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH;
  eval ($HOMEBREW_PREFIX/bin/brew shellenv)
end
fish_add_path "$HOME/.*/bin"
fish_add_path "$HOME/go/bin"
fish_add_path -g "./node_modules/.bin"
if status is-interactive
  oh-my-posh init fish --config '~/.config/pynappo.omp.yaml' | source
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
  if type -q vivid
    set LS_COLORS $(vivid generate ayu)
  end
  if type -q atuin
    atuin init fish | source
  end
  if type -q zoxide
    zoxide init fish | source
  end

  bind \cz 'fg 2>/dev/null; commandline -f repaint'

  # function git-auto-fetch --on-variable PWD
  #   if git rev-parse --is-inside-work-tree &>/dev/null
  #     git fetch &
  #   end
  # end
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
  abbr -a -- dot 'git --git-dir=$HOME/.files.git/ --work-tree=$HOME'
  abbr -a -- ldot 'lazygit --git-dir=$HOME/.files.git/ --work-tree=$HOME'
  abbr -a -- pm 'sudo pacman'
  abbr -a -- g 'git'
  abbr -a -- gdnvim 'nvim --listen /tmp/godot.pipe'
  abbr -a -- ntnvim 'nvim -u $HOME/.config/nvim/test/test-neo-tree.lua'
  abbr -a --command git co checkout
  abbr -a --command git ch cherry-pick
  abbr -a --command git c commit
  abbr -a --command git a add
  abbr -a --command git t tag
  abbr -a --command git s status
  abbr -a -- gpr 'gh pr checkout'
  abbr -a -- sudo 'sudo -s'
  abbr -a -- sn 'sudo EDITOR=nvim'
  abbr -a -- sc 'systemctl'
  abbr -a -- jc 'journalctl'
  abbr -a -- ts 'tree-sitter'
  abbr -a --set-cursor nman 'nvim "+Man %"'
  abbr -a --position anywhere .C "$XDG_CONFIG_HOME/"
  abbr -a --set-cursor f 'fd . % | fzf'
  abbr -a -- jammers 'mpv "https://www.youtube.com/playlist?list=PLg-SQpG3Qf59d1hzWtxsFqZt9n0e2llep" --no-video --no-resume-playback --volume=20'
  abbr -a -- ocr 'grim -g "$(slurp)" - | tesseract - - | wl-copy'
  # abbr -a -- wlsudo 'socat UNIX-LISTEN:/tmp/.X11-unix/X1 UNIX-CONNECT:/tmp/.X11-unix/X0 & sudo DISPLAY=:1'
  # abbr -a --set-cursor ibmconnect 'IBM_USER="%" begin; echo (secret-tool lookup ibmconnect $IBM_USER) | sudo openconnect https://vpnisv.isv.ihost.com --authgroup Anyconnect -u $IBM_USER --passwd-on-stdin; end'
  abbr -a --set-cursor :h 'nvim "+help %"'
  abbr -a -- pacup 'sudo pacman -Qqe > ~/.files/pacman.txt && sudo pacman -Qqm > ~/.files/paru.txt'
  abbr -a -- pr 'paru'
  abbr -a -- n 'nvim'
  abbr -a -- - 'prevd'
  abbr -a -- + 'nextd'

  abbr -a -- pacsearch 'pacman -Slq | fzf --multi --preview "pacman -Si {1}" | xargs -ro sudo pacman -S'
  abbr -a -- pacremove 'pacman -Qq | fzf --multi --preview "pacman -Qi {1}" | xargs -ro sudo pacman -Rns'
  abbr -a -- parusearch 'paru -Sl | awk \'{print $2($4=="" ? "" : " *")}\' | fzf --multi --preview \'paru -Si {1}\' | cut -d " " -f 1 | xargs -ro paru -S'
  abbr -a -- sshp 'ssh -o ServerAliveInterval=240'

  function edit
    echo $EDITOR $argv
  end
  function mz -d "mkdir and then z into it"
    mkdir $argv
    cd $argv
  end
  # abbr -a edit_texts --position command --regex ".+\.txt" --function edit


  function last_history_item
    echo $history[1]
  end
  abbr -a !! --position anywhere --function last_history_item

  if type -q eza
    abbr -a -- ls "eza --icons=auto"
    abbr -a -- la "eza --icons=auto --group --header --group-directories-first --long --all"
    abbr -a -- l "eza --icons=auto"
    function eza -d "eza with auto-git"
      if git rev-parse --is-inside-work-tree &>/dev/null
        command eza --git --classify $argv
      else
        command eza --classify $argv
      end
    end
  end
  # refresh sudo timeout
  alias sudo="/usr/bin/sudo -v; /usr/bin/sudo"
end
# for the sce dev tool
export PG_OF_PATH=/home/dle/code/cs134/of_v0.12.0_linux64gcc6_release
if type -q mise
  mise activate fish | source
end

