export GOPATH=~/go
export PATH=$HOME/bin:/usr/local/bin:$PATH:/Applications/MakeMKV.app/Contents/MacOS
export PATH=~/.tfswitch/bin:~/.tfswitch-bin:$PATH

# Source Antigen
source ~/.antigen.zsh
source ~/.p10k.zsh

CASE_SENSITIVE="true"

# 2. Use Antigen to load stuff
## Use oh-my-zsh
antigen use oh-my-zsh
## Use some plugins
antigen bundle fzf
antigen bundle git
antigen bundle docker
antigen bundle brew
antigen bundle macunha1/zsh-terraform
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle Aloxaf/fzf-tab
## Load a custom Theme
antigen theme romkatv/powerlevel10k

# 3. Commit Antigen Configuration
antigen apply

# load auto-complete dependencies
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

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

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# set min-height to make sure tehre's room for the preview window
zstyle ':fzf-tab:complete:*:*' fzf-pad 10

zstyle ':fzf-tab:complete:*:*' fzf-preview 'eval ~/.fzf-dynamic-preview "${realpath}"'

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps -p $word -o '%cpu=CPU,%mem=Memory,command=Command' -c'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

source <(kubectl completion zsh)

local real_tf=$(which terraform)
terraform () {
    if [[ "$#" == "1" && "$1" == "workspace" ]]; then
        $real_tf workspace select `$real_tf workspace list | sed '/^$/d' | fzf | cut -c 3-`
    else
        $real_tf "$@"
    fi
}
