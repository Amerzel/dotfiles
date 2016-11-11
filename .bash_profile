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

PATH=$HOME/bin:$PATH

export PATH
unset USERNAME

export PATH=.:/Users/james/local/bin:/Users/james/bin:/Users/james/work/clean/web_src/linear/scripts:/usr/local/bin:/bin:/usr/sbin:/sbin:/usr/bin:/Users/james/bin:/usr/local/mysql/bin

# Marmalade SDK addition: please do not edit these lines
export PATH=$PATH:"/Applications/Marmalade.app/Contents/s3e/bin"
export S3E_DIR=/Applications/Marmalade.app/Contents/s3e
# Marmalade SDK addition: end
