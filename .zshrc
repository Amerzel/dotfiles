#1/bin/zsh

# Uncomment to measure load time
# bootTimeStart=$(gdate +%s%N)

#Terminal
export TERM=xterm-256color

# Set applicaiton new files default permissions
umask 0002
unset USERNAME

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme to use
ZSH_THEME="powerlevel9k/powerlevel9k"

# Plugins
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
  aws
  docker
  extract
  jira
  jsontools
  node
  npm
  osx
  pip
  vscode
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-z
)

# Source files to load
typeset -ga sources

sources+="$HOME/.path"
sources+="$HOME/.aliases"
sources+="$HOME/.exports"
sources+="$HOME/.exports_osx"
sources+="$HOME/.exports_work"
sources+="$ZSH/oh-my-zsh.sh"
sources+="$HOME/.zsh_prompt"

foreach file (`echo $sources`)
  if [[ -a $file ]]; then
    # sourceIncludeTimeStart=$(gdate +%s%N)
    source $file
    # sourceIncludeDuration=$((($(gdate +%s%N) - $sourceIncludeTimeStart)/1000000))
    # echo $sourceIncludeDuration ms runtime for $file
  fi
end

# Uncomment to print out load time
# bootTimeDuration=$((($(gdate +%s%N) - $bootTimeStart)/1000000))
# echo $bootTimeDuration ms overall boot duration
