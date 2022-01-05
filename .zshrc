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
antigen bundle git
antigen bundle docker
antigen bundle kubernetes
antigen bundle brew
antigen bundle kubernetes
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
