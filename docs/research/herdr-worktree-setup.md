# Automatic worktree setup with Herdr and Worktrunk

Research date: 2026-07-11

## Recommendation

Use one of these paths, depending on the ordering requirement:

1. If setup must finish before an agent or dev command starts, route creation through
   `herdr-worktrunk` and put the setup command in Worktrunk's `pre-start` hook. This
   hook runs once for a newly created worktree and blocks later Worktrunk steps until
   it completes.
2. If setup may run asynchronously after Herdr opens the workspace, use a very small
   Herdr plugin subscribed to `worktree.created`. This keeps Herdr's built-in UI and
   is the least machinery.
3. If the same behavior must apply to Herdr, Worktrunk, and plain
   `git worktree add`, use Git's `post-checkout` hook with a linked-worktree guard and
   an idempotence marker.

`herdr-plus` is best when the goal also includes creating a standard tab/pane layout.
It is not the most precise tool for running a one-time setup script.

## Primary-source findings

### Native Herdr event plugin

Herdr 0.7 exposes executable plugin event hooks. `worktree.create` emits
`worktree.created`; the event includes the opened workspace and the created worktree.
Event commands receive `HERDR_PLUGIN_EVENT_JSON`, and their output is available through
Herdr's plugin command logs. A plugin can therefore subscribe to only
`worktree.created`, extract the checkout path, change to it, and invoke a dispatcher or
repo-local setup script.

Herdr starts event commands asynchronously. Its runtime calls `start_plugin_command`
without waiting for the child command, and its worktree-create test expects the hook's
log status still to be `Running` when creation completes. This makes the mechanism
automatic but not a readiness barrier.

Sources:

- [Herdr Socket API: worktree events and plugin event hooks](https://herdr.dev/docs/socket-api/)
- [Herdr event-hook runtime source](https://github.com/ogulcancelik/herdr/blob/master/src/app/api/plugins/runtime.rs#L183-L220)
- [Herdr CLI plugin reference](https://herdr.dev/docs/cli-reference/)

### `herdr-worktrunk`

The plugin replaces Herdr's create/switch action with an `fzf` picker. It lets
Worktrunk create or switch the checkout, so Worktrunk lifecycle hooks run, then opens
the resulting checkout through `herdr worktree open`. Its default presentation is a
native nested Herdr worktree workspace; it can alternatively open a tab. It requires
Herdr 0.7+, Worktrunk 0.60+, Bash, `fzf`, and `jq`, and supports macOS and Linux.

This is the purpose-built choice when Worktrunk should own the lifecycle. The tradeoff
is that hooks run only when creation goes through this plugin/Worktrunk; Herdr's normal
context-menu worktree creation remains a bypass. The repository is also a small,
young integration compared with Herdr or Worktrunk themselves.

Sources:

- [`herdr-worktrunk` README](https://github.com/devashish2203/herdr-worktrunk)
- [`picker.sh` implementation](https://github.com/devashish2203/herdr-worktrunk/blob/main/picker.sh)
- [Plugin manifest](https://github.com/devashish2203/herdr-worktrunk/blob/main/herdr-plugin.toml)

### Worktrunk hook semantics

Worktrunk's `pre-start` runs once on new worktree creation and blocks `post-start` and
the execute step. `post-start` also runs once, but in the background. Project hooks
live in `.config/wt.toml` and are approval-gated; user hooks live in
`~/.config/worktrunk/config.toml`, need no approval, and can be global or scoped under
`[projects."<identifier>"]`. Worktrunk supplies variables such as
`{{ worktree_path }}`, `{{ repo_path }}`, and `{{ branch }}` and keeps background hook
logs.

Sources:

- [Worktrunk hook reference](https://worktrunk.dev/hook/)
- [Worktrunk configuration reference](https://worktrunk.dev/config/)

### `herdr-plus`

`herdr-plus` subscribes to both `worktree.created` and `worktree.opened`. For a matching
repository layout, it fills tabs and panes and runs each configured startup command.
Layouts are centrally configured as one or more repository-matching TOML files. That
makes it attractive when setup and a repeatable terminal layout are the same workflow.

For setup alone, it has two mismatches: the startup command is modeled as a pane/tab
command, and matching layouts also apply when an existing worktree is opened, so a
setup command may run again. Because it uses Herdr event hooks, it is asynchronous as
well.

Sources:

- [`herdr-plus` repository](https://github.com/cloudmanic/herdr-plus)
- [`herdr-plus` worktree auto-layout documentation](https://herdrplus.com/docs/worktrees/)

### Git `post-checkout`

Git explicitly runs `post-checkout` after `git worktree add` unless `--no-checkout` is
used, and runs non-bare hooks from the worktree root. This is the only option here that
is independent of the program creating the worktree.

It also runs after ordinary `git checkout`, `git switch`, and clone, so a general hook
needs to detect a linked worktree and be idempotent. A global `core.hooksPath` dispatcher
can cover all repositories and invoke a conventional repo-local setup entry point when
present. Hook failure occurs after checkout has happened, so setup failure cannot
transactionally undo worktree creation and should be handled deliberately.

Source: [Git githooks documentation](https://git-scm.com/docs/githooks#_post_checkout)

## Comparison

| Mechanism | Automatic from Herdr UI | Setup ordering | Scope/config | Main drawback |
|---|---:|---|---|---|
| Small Herdr `worktree.created` plugin | Yes | Asynchronous | One global plugin; dispatcher can select repo script | Agent can race setup |
| `herdr-worktrunk` + `pre-start` | Only through plugin action | Blocking, once per new worktree | Worktrunk user config or committed `.config/wt.toml` | Built-in Herdr creation bypasses it |
| `herdr-worktrunk` + `post-start` | Only through plugin action | Background, once per new worktree | Same as above | No readiness guarantee |
| `herdr-plus` auto-layout | Yes | Asynchronous; also runs on open | Central repo-matching layout files | Layout-oriented and may rerun setup |
| Git `post-checkout` | Yes | Synchronous Git hook invocation | Global or per-repo hooks path | Also fires on checkout/switch/clone |
| Wrapper/custom keybinding | Only through wrapper/key | Chosen by wrapper | Central script/config | Easy to bypass; redundant with event hooks |
| `direnv`/shell-entry trigger | No; runs on first directory entry | Lazy | Per-repo `.envrc` plus trust | Not actually a creation hook |
