## load prompt theme, generated with airline's promptline
source ~/.zsh/promptline.sh


#  Plugins
############

## auto-install plugin-manager
if [ ! -e ~/.zsh/antigen ]; then
  mkdir -p ~/.zsh
  git clone https://github.com/zsh-users/antigen.git ~/.zsh/antigen
fi
source ~/.zsh/antigen/antigen.zsh

# adds support for more special keys
antigen bundle https://github.com/belak/zsh-utils editor
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
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+="__zshrc_toggle_ctrl_z"

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

## load ssh-agent
__zshrc_load_ssh_agent() {
  type ssh-agent >/dev/null 2>/dev/null
  if [ $? -eq 0 ] && [[ -z "$SSH_AUTH_SOCK" ]]; then
    local ssh_env_path="/tmp/ssh-agent-$(id -u).env"
    if [[ -n "$(ps -o comm -u $(id -u) | grep ssh-agent)" ]] && [[ -e "${ssh_env_path}" ]]; then
      source "$ssh_env_path" >/dev/null
    else
      echo "" > "$ssh_env_path"
      chmod 700 "$ssh_env_path" && ssh-agent > "$ssh_env_path"
      source "$ssh_env_path" >/dev/null
    fi
  fi
}
__zshrc_load_ssh_agent


## show SSH status in tmux statusline
__zshrc_tmux_ssh_status() {
  if [[ -n "$TMUX" ]]; then
    local _tmux_status_right="$(tmux show-options -gv status-right)"
    if [[ -n "$SSH_CONNECTION" ]]; then
      tmux set-option -s status-right "${_tmux_status_right}#[fg=color3]#[fg=color15,bg=color3] SSH "
    else
      tmux set-option -s status-right "${_tmux_status_right}"
    fi
  fi
}
__zshrc_tmux_ssh_status


## Ctrl-z toggles the latest foreground job, preserving zsh input buffer
## based on: https://stackoverflow.com/q/30662735
__zshrc_toggle_ctrl_z() {
  zle push-input
  BUFFER=" fg"
  zle accept-line
}
zle -N __zshrc_toggle_ctrl_z


## support OSC 2 (set window title)
__zshrc_set_windowtitle_precmd() {
	local cwd="${PWD/#$HOME/~}"
	printf '\033]2;%s\033\\' "$USER@$HOST:$cwd"
}
precmd_functions+=(__zshrc_set_windowtitle_precmd)
__zshrc_set_windowtitle_preexec() {
	if [[ -n "$1" ]]; then
		printf '\033]2;%s\033\\' "$1"
	else
		printf '\033]2;%s\033\\' "$2"
	fi
}
preexec_functions+=(__zshrc_set_windowtitle_preexec)


## urlencode string for OSC 7
## based on: https://unix.stackexchange.com/a/60698
## used by: __zshrc_vte_osc7
__zshrc_urlencode_osc7() {
  local string="$1"; local format=""; set --
  while
	local literal="${string%%[!-._~0-9A-Za-z/]*}"
	if [ -n "$literal" ]; then
	  format="$format%s"
	  set -- "$@" "$literal"
	  string="${string#$literal}"
	fi
	[ -n "$string" ]
  do
	local tail="${string#?}"
	local head="${string%$tail}"
	format="$format%%%02x"
	set -- "$@" "'$head"
	string="$tail"
  done
  printf "$format" "$@"
}


## support OSC 7 (advertize cwd)
## support OSC 133 (semantic prompts)
## based on: `vte.sh`
__zshrc_vte_osc7() {
	local errsv="$?"
	printf "\033]7;file://%s%s\033\\" "$HOST" "$(__zshrc_urlencode_osc7 "$PWD")"
	return $errsv
}
chpwd_functions+=(__zshrc_vte_osc7)
__zshrc_vte_osc7
__zshrc_vte_osc133() {
	if [[ "$PS1" != *\]133\;* ]] && [[ $- == *i* ]]; then
		PS1=$'%{\e]133;D;%?;aid=zsh\e\\\e]133;A;aid=zsh\e\\%}'"$PS1"$'%{\e]133;B\e\\%}'
		#PS2=$'%{\e]133;A;aid=zsh\e\\%}'"$PS2"$'%{\e]133;B\e\\%}'
		__zshrc_vte_osc133_preexec() {
			local errsv="$?"
			printf '\e]133;C\e\\\r'
			return $errsv
		}
		preexec_functions=(__zshrc_vte_osc133_preexec $preexec $preexec_functions)
		unset preexec
	fi
}
precmd_functions+=(__zshrc_vte_osc133)


#  Keybinds
#############

autopair-init

bindkey 'OA' history-substring-search-up
bindkey 'OB' history-substring-search-down
bindkey '[A' history-substring-search-up
bindkey '[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

bindkey '\C-z' __zshrc_toggle_ctrl_z
bindkey '\C-x\C-e' edit-command-line

