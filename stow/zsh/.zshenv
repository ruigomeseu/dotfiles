# Read by every zsh, including the non-interactive shells coding agents run
# commands in. Environment only; keep it fast and silent. Interactive setup
# lives in .zshrc.

typeset -U path PATH

# Machine-local settings and secrets (tokens etc.). Never commit this file.
[[ -r "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"

# User tool paths; later entries end up first. mise shims make mise-managed
# tools resolve without `mise activate`, which only interactive shells run.
for _dir in \
  "$HOME/.local/share/mise/shims" \
  "$HOME/.bun/bin" \
  "$HOME/.opencode/bin" \
  "$HOME/.strix/bin" \
  "$HOME/.local/bin"; do
  [[ -d $_dir ]] && path=("$_dir" $path)
done
unset _dir

if (( $+commands[nvim] )); then
  export EDITOR=nvim VISUAL=nvim
fi

# OS-specific environment.
case $OSTYPE in
  darwin*) [[ -r "$HOME/.config/zsh/macos.zsh" ]] && source "$HOME/.config/zsh/macos.zsh" ;;
  linux*) [[ -r "$HOME/.config/zsh/linux.zsh" ]] && source "$HOME/.config/zsh/linux.zsh" ;;
esac

# Fallback for coding agents still running commands in zsh (Claude Code sets
# CLAUDECODE, Codex sets CODEX_THREAD_ID). Claude Code is set to bash and Codex
# is asked to use it; if one doesn't, make zsh behave like bash where agents
# trip most: let unmatched globs pass through (grep --include=*.ts), split
# unquoted $VARs, and never page.
if [[ -n $CLAUDECODE || -n $CODEX_THREAD_ID ]] && [[ ! -o interactive ]]; then
  setopt NO_NOMATCH SH_WORD_SPLIT
  export PAGER=cat GIT_PAGER=cat
fi
