# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi
## custom workdir creation
if $(hostname | grep -q dev) ; then
  workdir=/data_storage/work/$(whoami)
  if [ ! -d $workdir ]; then
        mkdir $workdir
  fi

  if [ ! -h ~/work ]; then
        ln  -s $workdir ~/work
  fi
  if [ -f ~/.cvswork ]; then
        chmod 777 ~/.cvswork
  fi
fi

if [ -d ~/.ssh ]; then
    chmod 700 .ssh 2> /dev/null
    chmod 600 .ssh/* 2> /dev/null
fi


umask 002

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
unset USERNAME
