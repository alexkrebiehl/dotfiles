export GOPATH=~/go
export PATH=$HOME/bin:/usr/local/bin:$PATH:/Applications/MakeMKV.app/Contents/MacOS
export PATH=~/.tfswitch-bin:$PATH

# Source Antigen
source ~/.antigen.zsh
source ~/.p10k.zsh

CASE_SENSITIVE="true"

# 2. Use Antigen to load stuff
## Use oh-my-zsh
antigen use oh-my-zsh
## Use some plugins
antigen bundle fzf
antigen bundle Aloxaf/fzf-tab
antigen bundle git
antigen bundle docker
antigen bundle kubernetes
antigen bundle brew
antigen bundle kubernetes
antigen bundle macunha1/zsh-terraform
antigen bundle zsh-users/zsh-autosuggestions
## Load a custom Theme
antigen theme romkatv/powerlevel10k

# 3. Commit Antigen Configuration
antigen apply

# 4. ZSH customizations
## Appends every command to the history file once it is executed
setopt inc_append_history
## Reloads the history whenever you use it
setopt share_history

# 5. Aliases
alias ll="ls -alh"
alias flushdnscache="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;"
alias k="kubectl"
alias kga="kubectl get all --output=wide"

function f () {
    fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'
}

local real_tf=$(which terraform)
terraform () {
    if [[ "$#" == "1" && "$1" == "workspace" ]]; then
        $real_tf workspace select `$real_tf workspace list | sed '/^$/d' | fzf | cut -c 3-`
    else
        $real_tf "$@"
    fi
}
