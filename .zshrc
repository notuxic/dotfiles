## load prompt theme, generated with airline's promptline
source ~/.zsh/promptline.sh


#  Plugins
############

## auto-install plugin-manager
if [ ! -e ~/.zsh/antigen.zsh ]
then
  mkdir -p ~/.zsh
  curl -L git.io/antigen > ~/.zsh/antigen.zsh
fi
source ~/.zsh/antigen.zsh

# adds support for more special keys
antigen bundle https://github.com/belak/zsh-utils editor
# automatically activate/deactivate python virtualenvs
antigen bundle MichaelAquilina/zsh-autoswitch-virtualenv
# autopair
antigen bundle hlissner/zsh-autopair
# fish-style completion suggestions
antigen bundle zsh-users/zsh-autosuggestions
# syntax highlighting for prompt input
antigen bundle zsh-users/zsh-syntax-highlighting
# fish-style history search
antigen bundle zsh-users/zsh-history-substring-search

antigen apply


#  Plugin-Config
##################

# zsh-uers/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=11"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+="toggle-ctrl-z"

# zsh-users/zsh-syntax-highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=green'
ZSH_HIGHLIGHT_STYLES[alias]='fg=blue'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=blue'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue'
ZSH_HIGHLIGHT_STYLES[command]='fg=blue'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[comment]='fg=11'

# zsh-users/zsh-history-substring-search
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="underline"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=""
HISTORY_SUBSTRING_SEARCH_FUZZY=1
#HISTORY_SUBSTRING_SEARCH_PREFIXED=1
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1


#  Config
###########

setopt EMACS
setopt INTERACTIVE_COMMENTS
#setopt PATH_DIRS
setopt RM_STAR_SILENT
export ZLE_RPROMPT_INDENT=0

# history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY
setopt HIST_IGNORE_SPACE

# editing buffer with $EDITOR
autoload -z edit-command-line
zle -N edit-command-line


#  Snippets
#############

## show SSH status in tmux statusline
tmux-ssh-status() {
  if [[ -n ${TMUX} ]]
  then
    local _tmux_status_right="$(tmux show-options -gv status-right)"
    if [[ -n ${SSH_CONNECTION} ]]
    then
      tmux set-option -s status-right "${_tmux_status_right}#[fg=color3]#[fg=color15,bg=color3] SSH "
    else
      tmux set-option -s status-right "${_tmux_status_right}"
    fi
  fi
}
tmux-ssh-status

## Ctrl-z toggles the latest foreground job, preserving zsh input buffer
## based on: https://stackoverflow.com/q/30662735
toggle-ctrl-z () {
  zle push-input
  BUFFER=" fg"
  zle accept-line
}
zle -N toggle-ctrl-z


#  Keybinds
#############

autopair-init

bindkey 'OA' history-substring-search-up
bindkey 'OB' history-substring-search-down
bindkey '[A' history-substring-search-up
bindkey '[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

bindkey '\C-z' toggle-ctrl-z
bindkey '\C-x\C-e' edit-command-line

