typeset -U path PATH

# Emacs bindings
bindkey -e

# Persistent history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY
alias history='history -50'

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

# mise needs to activate before tools installed through mise are initialized.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Navigation and listings
if command -v eza >/dev/null 2>&1; then
  alias ls='eza'
  alias l='eza -lah'
  alias la='eza -lAh'
  alias ll='eza -lh'
  alias lsa='eza -lah'
else
  if [[ $OSTYPE == darwin* ]]; then
    alias ls='ls -G'
  else
    alias ls='ls --color=auto'
  fi
  alias l='ls -lah'
  alias la='ls -lAh'
  alias ll='ls -lh'
  alias lsa='ls -lah'
fi

alias ggp='git push origin $(git symbolic-ref --short HEAD)'
alias lg='lazygit'
alias dateutc='date -u +"%Y-%m-%dT%H:%M:%SZ"'

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
elif command -v batcat >/dev/null 2>&1; then
  alias cat='batcat --paging=never'
fi

if command -v nvim >/dev/null 2>&1; then
  alias vim='nvim'
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

copydeep() {
  if [[ -z $1 || -z $2 ]]; then
    printf 'usage: cpd file /path/path1/etc...\n'
    return 1
  fi

  mkdir -p "$2" || {
    printf "error: unable to create '%s' (check write permission)\n" "$2"
    return 1
  }
  cp "$1" "$2"
}
alias cpd='copydeep'

ssh() {
  command ssh "$@"
  local status=$?

  stty sane < /dev/tty
  printf '\033[<u\033[?1049l\033[<u\033[?1l\033[?1000l\033[?1002l\033[?1003l\033[?1004l\033[?1006l\033[?1015l\033[?2004l' > /dev/tty

  return $status
}

# Optional interactive tools
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

if command -v carapace >/dev/null 2>&1; then
  source <(carapace _carapace)
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Syntax highlighting should be sourced near the end of the file.
if [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif command -v brew >/dev/null 2>&1; then
  _zsh_syntax_highlighting="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -r $_zsh_syntax_highlighting ]] && source "$_zsh_syntax_highlighting"
  unset _zsh_syntax_highlighting
fi

# Fix Delete inside tmux sessions.
bindkey -e '^[[3~' delete-char

# Optional user tools
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
[[ -d "$HOME/.bun/bin" ]] && path=("$HOME/.bun/bin" $path)
[[ -d "$HOME/.opencode/bin" ]] && path=("$HOME/.opencode/bin" $path)

if command -v wt >/dev/null 2>&1; then
  eval "$(command wt config shell init zsh)"
fi

# Load small OS-specific additions without making the shared config platform-specific.
case $OSTYPE in
  darwin*)
    [[ -r "$HOME/.config/zsh/macos.zsh" ]] && source "$HOME/.config/zsh/macos.zsh"
    ;;
  linux*)
    [[ -r "$HOME/.config/zsh/linux.zsh" ]] && source "$HOME/.config/zsh/linux.zsh"
    ;;
esac

# dcg: warn if its Claude Code hook has been removed.
if command -v dcg >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  if [[ -f "$HOME/.claude/settings.json" ]] &&
    ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg$"))' \
      "$HOME/.claude/settings.json" >/dev/null 2>&1; then
    printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
  fi
fi

# Mirror manually installed Claude Code plugins to k12. Replays marketplace
# adds/removes, plugin installs/uninstalls, enabled flags, and updates through
# the claude CLI on k12 rather than copying ~/.claude/plugins, whose registries
# hold absolute macOS paths. Safe to rerun. Pass --dry-run to print the remote
# script instead of running it.
sync-plugins-k12() {
  local plugins_dir="$HOME/.claude/plugins"
  local settings="$HOME/.claude/settings.json"
  local script='export PATH="$HOME/.local/bin:$PATH"
set -u
fail=0
reg=~/.claude/plugins/installed_plugins.json
mk=~/.claude/plugins/known_marketplaces.json
cfg=~/.claude/settings.json
'

  # Local state, passed to k12 as zsh arrays.
  local -a markets plugins enabled
  markets=($(jq -r 'keys[]' "$plugins_dir/known_marketplaces.json"))
  plugins=($(jq -r '.plugins | keys[]' "$plugins_dir/installed_plugins.json"))
  enabled=($(jq -r '.enabledPlugins // {} | to_entries[] | select(.value) | .key' "$settings"))
  script+="markets=(${markets[*]})"$'\n'
  script+="plugins=(${plugins[*]})"$'\n'
  script+="enabled=(${enabled[*]})"$'\n'

  # Marketplaces: add local ones (no-op if present).
  local repo
  for repo in $(jq -r '.[].source.repo // empty' "$plugins_dir/known_marketplaces.json"); do
    script+="claude plugin marketplace add '$repo' || fail=1"$'\n'
  done

  script+='
# Uninstall plugins not installed locally.
for id in $(jq -r ".plugins | keys[]" "$reg"); do
  (( ${plugins[(Ie)$id]} )) || claude plugin uninstall -y "$id" || fail=1
done

# Remove marketplaces not known locally (after uninstalls, which may depend on them).
for name in $(jq -r "keys[]" "$mk"); do
  (( ${markets[(Ie)$name]} )) || claude plugin marketplace remove "$name" || fail=1
done

# Install missing plugins. Skip present ones: reinstalling a disabled plugin re-enables it.
for id in $plugins; do
  jq -e --arg id "$id" ".plugins[\$id]" "$reg" >/dev/null 2>&1 || claude plugin install -y "$id" || fail=1
done

# Match enabled flags. enable/disable exit non-zero if already in that state.
for id in $plugins; do
  cur=$(jq -r --arg id "$id" ".enabledPlugins[\$id] // false" "$cfg")
  if (( ${enabled[(Ie)$id]} )); then
    [[ $cur == true ]] || claude plugin enable -s user "$id" || fail=1
  else
    [[ $cur == false ]] || claude plugin disable -s user "$id" || fail=1
  fi
done

# Update enabled plugins to the latest marketplace version.
claude plugin marketplace update || fail=1
for id in $enabled; do
  claude plugin update -y "$id" || fail=1
done

exit $fail
'

  if [[ "${1:-}" == "--dry-run" ]]; then
    printf '%s' "$script"
    return 0
  fi

  printf '%s' "$script" | ssh k12 'zsh -c "$(cat)"'
}

# Mirror npx-managed skills, Claude Code skill links, and Claude Code plugins
# to k12.
sync-skills-k12() {
  local dry_run=()

  if [[ "${1:-}" == "--dry-run" ]]; then
    dry_run=(-n)
  fi

  rsync -av "${dry_run[@]}" --delete \
    "$HOME/.agents/skills/" \
    k12:.agents/skills/ &&

  rsync -av "${dry_run[@]}" \
    "$HOME/.agents/.skill-lock.json" \
    k12:.agents/.skill-lock.json &&

  rsync -av "${dry_run[@]}" --delete \
    "$HOME/.claude/skills/" \
    k12:.claude/skills/ &&

  sync-plugins-k12 "${1:-}"
}

# strix
export PATH=/Users/rgomes/.strix/bin:$PATH

# Added by cua-driver-rs installer — see https://github.com/trycua/cua
export PATH="/Users/rgomes/.local/bin:$PATH"
