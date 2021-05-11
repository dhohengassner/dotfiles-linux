# debug startup time
# zmodload zsh/zprof

# Path to your oh-my-zsh installation.
export ZSH=/home/dh/.oh-my-zsh

# set code as editor
export EDITOR=code
export KUBE_EDITOR='code --wait'

# See https://github.com/dhohengassner/zsh-theme-racotecnic
ZSH_THEME="racotecnic"

# lazy load any custom functions
lazyload_fpath=$HOME/.zsh/autoload
fpath=($lazyload_fpath $fpath)
if [[ -d "$lazyload_fpath" ]]; then
    for func in $lazyload_fpath/*; do
        autoload -Uz ${func:t}
    done
fi
unset lazyload_fpath

## plugin environment vars

# command-time
export ZSH_COMMAND_TIME_MIN_SECONDS=1
export ZSH_COMMAND_TIME_COLOR="yellow"

# autosuggest
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# completion
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
    compinit -i
else
    compinit -C -i
fi

# stolen autocomplete tweaks from https://github.com/webframp/dotfiles/blob/master/home/.zshrc
unsetopt menu_complete

# completion performance improvements
# Force prefix matching, avoid partial globbing on path
zstyle ':completion:*' accept-exact '*(N)'
# enable completion cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.local/share/zsh/cache

# Ignore completion for non-existent commands
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
#zstyle ':completion:*:functions' ignored-patterns '_*'


# completion behavior adjustments
# Case insensitive, partial-word and substring competion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*:*:*:*:*' menu select
# zstyle ':completion:*' special-dirs true

# # Colors in the completion list
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# from: vault -autocomplete-install
# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/local/bin/vault vault

source $ZSH/oh-my-zsh.sh

# custom key bindings
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# gitlab token for scripting and querying appsgit
export GITLAB_TOKEN="$(echo $(<~/dh_values.json) | jq -r '.gitlab.scriptToken')"

# K8s variables
export KUBECONFIG=~/.kube/dh-test

# Groovy
export GROOVY_HOME=/usr/local/opt/groovy/libexec

# direnv
eval "$(direnv hook zsh)"

# execute all .zsh files in HOME directory - some custom functions
for ZFILE in $HOME/.zsh/*; do
	source $ZFILE
done

## Source plugins last
# static method, after updates run:
# antibody bundle <~/.zsh_plugins.txt > ~/.zsh_plugins.sh
source ~/.zsh_plugins.sh

# https://bash-my-aws.org/
source ~/.bash-my-aws/aliases
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
source ~/.bash-my-aws/bash_completion.sh

# show startup time
# zprof
# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
