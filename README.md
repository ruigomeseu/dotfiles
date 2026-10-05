# Getting started

## MacOS

Install Xcode from the App Store

```
# Install Xcode Command Line Tools
xcode-select --install
sudo xcodebuild -license accept

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install git
brew install git

# Run script
cd macos
./install.sh
```

### Not automated

- Hide menu bar
- Tmux Plugin Manager
  - https://github.com/tmux-plugins/tpm

## Linux

Only the shell and agent config is used on Linux. See
[docs/k12.md](docs/k12.md) for how the k12 dev box is set up.

## Linking dotfiles

`scripts/link` links the dotfiles into `$HOME` with GNU Stow (needs `stow` and
`jq`). It is safe to rerun, and moves any regular file in the way to
`~/.dotfiles-backup/<timestamp>/` before linking. macOS links every package
under `stow/`; Linux links `zsh`, `claude` and `codex`. Pass package names to
link only those: `scripts/link nvim`.

## Machine-local setup

- Secrets and machine-only environment go in `~/.zshenv.local`, which
  `.zshenv` sources. It is not tracked.
- Coding agents run commands in bash, not zsh. `.zshrc` returns early for
  non-interactive shells, so agents never get its aliases or functions.
  `scripts/link` sets `CLAUDE_CODE_SHELL=/bin/bash` in
  `~/.claude/settings.json`. That file isn't stowed: it holds machine-specific
  paths (hooks, auto mode) and Claude Code and hook installers keep editing it.
  Codex has no shell setting; `stow/codex/.codex/AGENTS.md` asks it for bash.
- Bash agent shells don't read `.zshenv`; they use the PATH the agent was
  launched with (plus `~/.profile`), so start agents from an environment that
  already has mise tools on PATH.

## Resources

- https://medium.com/@protiumx/bash-gnu-stow-take-a-walk-while-your-new-macbook-is-being-set-up-351a6f2f9225