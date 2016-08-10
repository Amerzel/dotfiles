# .bashrc

# User specific aliases and functions

# set proper TERM for tmux
# xterm-256color messes with vim's background coloring, should be screen-256color, but thats not installed on all machines
#[ -n "$TMUX" ] && export TERM=screen-256color
#export TERM=screen-256color # Seems like screen-256color is now installed and/or working properly
#export TERM=xterm # Ubuntu testing for xfce4-terminal
export TERM=xterm-256color # Ubuntu testing for xfce4-terminal

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.bashrc_work ]; then
    . ~/.bashrc_work
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_aliases_work ]; then
    . ~/.bash_aliases_work
fi

if [ -f ~/.bash_prompt_windows ]; then
    . ~/.bash_prompt_windows
elif [ -f ~/.bash_prompt_simple ]; then
    . ~/.bash_prompt_simple
elif [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
elif [ -f ~/.bash_ps1 ]; then
    . ~/.bash_ps1
fi

export EDITOR=vim
export PAGER=less

NPM_PACKAGES="~/.npm-packages"
PATH="$NPM_PACKAGES/bin:$PATH"
unset MANPATH
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

umask 0002

#stty -ixon

aa_256 ()
{
    ( x=`tput op` y=`printf %$((${COLUMNS}-6))s`;
    for i in {0..256};
    do
    o=00$i;
    echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;
    done )
}

export NVM_DIR="/home/james/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# remap capslock to esc
xmodmap ~/.xmodmap
setxkbmap -option 'caps:escape'

# ubuntu ssh agent stuff?
## only ask for my SSH key passphrase once!
#use existing ssh-agent if possible
#if [ -f ${HOME}/.ssh-agent ]; then
#   . ${HOME}/.ssh-agent > /dev/null
#fi
#if [ -z "$SSH_AGENT_PID" -o -z "`/usr/bin/ps -a|/usr/bin/egrep \"^[ ]+$SSH_AGENT_PID\"`" ]; then
#   /usr/bin/ssh-agent > ${HOME}/.ssh-agent
#   . ${HOME}/.ssh-agent > /dev/null
#fi
#ssh-add ~/.ssh/id_rsa

eval `keychain --eval --agents ssh id_rsa`
