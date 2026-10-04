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

## Machine-local setup

- Secrets and machine-only environment go in `~/.zshenv.local`, which
  `.zshenv` sources. It is not tracked.
- Coding agents run commands in bash, not zsh. `.zshrc` returns early for
  non-interactive shells, so agents never get its aliases or functions. Claude
  Code's `~/.claude/settings.json` is not stowed (Claude Code rewrites it), so
  add its environment on each machine:

  ```
  f=~/.claude/settings.json
  jq '.env += {CLAUDE_CODE_SHELL: "/bin/bash", PAGER: "cat", GIT_PAGER: "cat"}' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  ```

  Codex has no shell setting; `stow/codex/.codex/AGENTS.md` asks it for bash.
  Bash agent shells don't read `.zshenv`; they use the PATH the agent was
  launched with (plus `~/.profile`), so start agents from an environment that
  already has mise tools on PATH.

## Resources

- https://medium.com/@protiumx/bash-gnu-stow-take-a-walk-while-your-new-macbook-is-being-set-up-351a6f2f9225