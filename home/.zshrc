#!/bin/zsh
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ark/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Keybinds
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward

# Prompt
setopt prompt_subst
autoload colors    
colors             

# Autocorrect
setopt correct
setopt correctall

# prevent autocorrect sudo vim -> sudo .vim, etc
alias sudo='nocorrect sudo'
alias git='nocorrect git'
alias ack='ag'
 
autoload -Uz vcs_info

# set some colors
for COLOR in RED GREEN YELLOW WHITE BLACK CYAN; do
    eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'        
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done                                                
PR_RESET="%{${reset_color}%}";       

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
FMT_BRANCH="${PR_GREEN}%b%u%c${PR_RESET}" # e.g. master¹²
FMT_ACTION="(${PR_CYAN}%a${PR_RESET}%)"   # e.g. (rebase-i)
FMT_PATH="%R${PR_YELLOW}/%S"              # e.g. ~/repo/subdir
 
# check-for-changes can be really slow.
# you should disable it, if you work with large repositories    
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr '¹'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '²'    # display ² if there are staged changes
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}//" "${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}//"              "${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""                             "%~"      

function precmd {       
    vcs_info 'prompt'         
}           

function lprompt {
    local brackets=$1
    local color1=$2  
    local color2=$3  
                      
    local bracket_open="${color1}${brackets[1]}${PR_RESET}"
    local bracket_close="${color1}${brackets[2]}"         
                                                              
    local git='$vcs_info_msg_0_'                          
    local cwd="${color2}%B%1~%b"
 
    PROMPT="${PR_RESET}${bracket_open}${git}${cwd}${bracket_close}%# ${PR_RESET}"
}                                                                                        
 
function rprompt {
    local brackets=$1
    local color1=$2  
    local color2=$3  
                      
    local bracket_open="${color1}${brackets[1]}${PR_RESET}"
    local bracket_close="${color1}${brackets[2]}${PR_RESET}"
    local colon="${color1}:"                               
    local at="${color1}@${PR_RESET}"                       
                                                             
    local user_host="${color2}%n${at}${color2}%m"                   
    local vcs_cwd='${${vcs_info_msg_1_%%.}/$HOME/~}'       
    local cwd="${color2}%B%20<..<${vcs_cwd}%<<%b"
    local inner="${user_host}${colon}${cwd}"
 
    RPROMPT="${PR_RESET}${bracket_open}${inner}${bracket_close}${PR_RESET}"
}
 
lprompt '[]' $BR_BRIGHT_BLACK $PR_WHITE
rprompt '()' $BR_BRIGHT_BLACK $PR_WHITE

alias mysql='mysql --i-am-a-dummy'
#alias git='~/bin/hub'
#

# perlbrew (mine)
#source ~/perl5/perlbrew/etc/bashrc
# perlbrew (system)
export PERLBREW_ROOT=/opt/perlbrew
source /opt/perlbrew/etc/bashrc

function git(){/home/ark/bin/hub "$@"}

# fix path
export PATH=$HOME/bin:$PATH
export EDITOR=vim

# fix terminal type
export TERM="screen-256color"
alias tmux="tmux -2"