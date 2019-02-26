#1/bin/zsh

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
  git
  gitfast
  jira
  json_tools
  node
  npm
  osx
  pip
  vscode
  zsh-autosuggestions
)

# Source files to load
typeset -ga sources

sources+="$HOME/.path"
sources+="$HOME/.aliases"
sources+="$HOME/.exports"
sources+="$HOME/.exports_work"
sources+="$ZSH/oh-my-zsh.sh"
sources+="$HOME/.zsh_prompt"

foreach file (`echo $sources`)
  if [[ -a $file ]]; then
    source $file;
  fi
end
