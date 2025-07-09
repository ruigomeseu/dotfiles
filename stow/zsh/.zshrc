# Emacs bindings
bindkey -e

# Enable persistent history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

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

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Set up zoxide to move between folders efficiently
eval "$(zoxide init zsh)"

# Set up the Starship prompt
eval "$(starship init zsh)"

# Set up atuin to track commands
eval "$(atuin init zsh)"

# Set up the editor
export EDITOR="nvim"
export VISUAL="nvim" 

# Set up the terminal
export TERM=xterm-256color

# Set up aliases
alias cat="bat --paging=never"
alias ls="eza"
alias cd="z"
alias vim="nvim"

# Set up zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Set up zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
