# zellij dynamic pane titles (append to ~/.bashrc)
#
# Emits an OSC 0 title escape that zellij renders in pane frames and in
# collapsed/stacked pane lines:
#   - while a command runs  -> the command being run
#   - at the prompt         -> user@host: cwd
# If a pane was renamed manually (Ctrl+p c or `zellij action rename-pane`),
# the manual name wins over this.

# >>> zellij-pane-title >>>
if [[ $- == *i* ]] && [[ ${TERM:-} != dumb ]]; then
    __zellij_title() { printf '\033]0;%s\007' "$1"; }
    trap '__zellij_title "$BASH_COMMAND"' DEBUG
    PROMPT_COMMAND='__zellij_title "${USER:-$(id -un)}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}"'
fi
# <<< zellij-pane-title <<<
