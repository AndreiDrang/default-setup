# zellij dynamic pane titles (append to ~/.bashrc)
#
# Emits an OSC 0 title that zellij renders in pane frames and in
# collapsed/stacked pane lines. Title = "[label — ] user@host: cwd",
# or "[label — ] running-command" while a command executes.
#
# `zlabel <text>`  — name this pane (label + path shown from then on)
# `zlabel`         — clear the label
#
# Labels are stored per pane id (zellij exports $ZELLIJ_PANE_ID) under
# ~/.cache/zellij-pane-labels/ and survive `exec bash` / pane reloads.
#
# Prefer zlabel over zellij's manual rename (Ctrl p c): a manual rename
# overrides the shell title and hides the path.

# >>> zellij-pane-title >>>
if [[ $- == *i* ]] && [[ ${TERM:-} != dumb ]]; then
    __zj_label_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zellij-pane-labels"
    mkdir -p "$__zj_label_dir" 2>/dev/null

    __zj_label() { local f="$__zj_label_dir/${ZELLIJ_PANE_ID:-0}"; [[ -r $f ]] && cat "$f"; }
    __zellij_title() { printf '\033]0;%s\007' "$1"; }
    __zj_prompt_title() {
        local l base
        l="$(__zj_label)"
        base="${USER:-$(id -un)}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}"
        if [[ -n $l ]]; then __zellij_title "$l — $base"; else __zellij_title "$base"; fi
    }
    __zj_run_title() {
        local l
        l="$(__zj_label)"
        if [[ -n $l ]]; then __zellij_title "$l — $*"; else __zellij_title "$*"; fi
    }
    zlabel() {
        local f="$__zj_label_dir/${ZELLIJ_PANE_ID:-0}"
        if [[ $# -eq 0 ]]; then rm -f "$f"; __zj_prompt_title
        else printf '%s' "$*" > "$f"; __zj_prompt_title; fi
    }

    trap '__zj_run_title "$BASH_COMMAND"' DEBUG
    PROMPT_COMMAND='__zj_prompt_title'
fi
# <<< zellij-pane-title <<<
