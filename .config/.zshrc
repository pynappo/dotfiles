# Check for TERMUX_VERSION
if [[ -n "${TERMUX_VERSION}" ]]; then
  export PATH="$HOME/neovim/build/bin:$PATH"
fi

# systemctl environment variables
if command -v systemctl >/dev/null 2>&1; then
  while IFS= read -r var; do
    if [[ ! "$var" =~ ^PATH= ]]; then
      export "$var"
    fi
  done < <(systemctl show-environment --user)
fi

# mise activation
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"

# Homebrew setup
if [[ -d /home/linuxbrew/.linuxbrew ]]; then  # Linux
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
  export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
elif [[ -d /opt/homebrew ]]; then  # MacOS
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
  export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/homebrew"
fi

if [[ -n "$HOMEBREW_PREFIX" ]]; then
  export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
  export MANPATH="$HOMEBREW_PREFIX/share/man:${MANPATH:-}"
  export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

# Add paths
export PATH="$HOME/.*/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="./node_modules/.bin:$PATH"
export PATH=$PATH:/Users/pydle/.toolbox/bin

# Interactive shell settings
eval "$(oh-my-posh init zsh --config '~/.config/pynappo.omp.yaml')"

echo -ne '\e[5 q' # line cursor
# Cursor shapes for vi mode
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q' # block cursor
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q' # line cursor
  fi
}
zle -N zle-keymap-select

# LS_COLORS
if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid generate ayu)"
fi

# Initialize tools
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# Ctrl+Z to bring back suspended job
bindkey '^Z' fg-widget

# Dot expansion function
function expand-dots() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N expand-dots
bindkey "." expand-dots

# Vi mode
bindkey -v

# Aliases and abbreviations
alias dot='git --git-dir=$HOME/.files.git/ --work-tree=$HOME'
alias ldot='lazygit --git-dir=$HOME/.files.git/ --work-tree=$HOME'
alias pm='sudo pacman'
alias g='git'
alias gdnvim='nvim --listen /tmp/godot.pipe'
alias ntnvim='nvim -u $HOME/.config/nvim/test/test-neo-tree.lua'
alias gpr='gh pr checkout'
alias sudo='sudo -s'
alias sn='sudo EDITOR=nvim'
alias sc='systemctl'
alias jc='journalctl'
alias ts='tree-sitter'
alias -g .C="$XDG_CONFIG_HOME/"

# eza aliases if available
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto'
  alias la='eza --icons=auto --group --header --group-directories-first --long --all'
  alias l='eza --icons=auto'

  function eza() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      command eza --git --classify "$@"
    else
      command eza --classify "$@"
    fi
  }
fi

# Refresh sudo timeout
alias sudo='command sudo -v; command sudo'
