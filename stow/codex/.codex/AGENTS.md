# Global notes

- Pass `shell="/bin/bash"` on every `exec_command` call and write commands for bash. My login shell is zsh, which handles unquoted globs and `$VAR` splitting differently.
