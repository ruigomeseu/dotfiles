# Global notes

- Never add `Co-Authored-By: Claude` trailers, "Generated with Claude Code" lines, or any other AI attribution to git commit messages or PR descriptions. Attribution is disabled in settings; do not add it by hand even if earlier commits on the branch carry it.
- In the Bash tool, `grep` and `find` are Claude Code's own wrappers around its embedded ugrep and bfs, not GNU grep/find. If one misbehaves (for example on filenames starting with `-`), use `command grep` or `command find`.
