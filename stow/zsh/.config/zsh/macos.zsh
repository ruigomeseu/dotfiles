# macOS-only paths
[[ -d "$HOME/Library/pnpm" ]] && path=("$HOME/Library/pnpm" $path)
[[ -d "$HOME/Library/Android/sdk/platform-tools" ]] && \
  path=("$HOME/Library/Android/sdk/platform-tools" $path)
