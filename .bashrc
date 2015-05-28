# .bashrc

# User specific aliases and functions

# set proper TERM for tmux
# xterm-256color messes with vim's background coloring, should be screen-256color, but thats not installed on all machines
#[ -n "$TMUX" ] && export TERM=screen-256color
export TERM=screen-256color # Seems like screen-256color is now installed and/or working properly

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

if [ -f ~/.bash_prompt_simple ]; then
    . ~/.bash_prompt_simple
elif [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
elif [ -f ~/.bash_ps1 ]; then
    . ~/.bash_ps1
fi

export EDITOR=vim
export PAGER=less

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
