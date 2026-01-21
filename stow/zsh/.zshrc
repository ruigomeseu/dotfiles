# Emacs bindings
bindkey -e

# Enable persistent history
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# ZSH shows only 15 items by default
alias history='history -50'

setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY

# Move to directories without cd
setopt autocd

# Initialize completion
autoload -U compinit; compinit

alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsa='ls -lah'
alias ggp='git push origin $(git symbolic-ref --short HEAD)'
alias lg='lazygit'

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Set up the Starship prompt
eval "$(starship init zsh)"

# Set up atuin to track commands
eval "$(atuin init zsh)"

# Set up the editor
export EDITOR="nvim"
export VISUAL="nvim" 

# Set up the terminal
export TERM=xterm-256color

copydeep () {
  [ -z $1 ] || [ -z $2 ] && {
    printf "usage: cpd file /path/path1/etc...\n";
    return 1
  }
  mkdir -p "$2" || {
    printf "error: unable to create directory '%s' (check write permission)\n" "$2";
    return 1
  }
  cp "$1" "$2"
}

# Set up aliases
alias cat="bat --paging=never"
alias ls="eza"
alias cd="z"
alias vim="nvim"
alias cpd="copydeep"
alias dateutc='date -u +"%Y-%m-%dT%H:%M:%SZ"'

zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# Set up zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# For some reason delete prints ~ (tilde) inside Tmux sessions
# This binding fixes that
bindkey -e '^[[3~' delete-char

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/Users/rgomes/.bun/_bun" ] && source "/Users/rgomes/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Set up zoxide to move between folders efficiently
if [[ $- == *i* ]]; then
  eval "$(zoxide init zsh)"
fi

export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/rgomes/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
