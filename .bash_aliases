#! /usr/bin/bash

alias la='ls -alh --color=tty'
alias ls='ls -alh --color=tty'
alias less='less -iRS'
alias ack5=acksearch

alias directorysize='du -h --max-depth=1 | sort -h'
alias tls='tmux list-sessions'
alias xit='exit'

# Git related aliases
alias gs='git status --untracked-files=all'
alias gu='git-update-tree'
alias gsu='git submodule update'
alias gco='git checkout'
alias gdom='git diff origin/master'
alias gdomno='git diff origin/master --name-only'
alias gdoi='git diff origin/integration'
alias gdoino='git diff origin/integration --name-only'
alias gl='git log'
alias glno='git log --name-only'
alias glp='git log --pretty=oneline --abbrev-commit --reverse origin/integration..'
alias glpno='git log --pretty=oneline --abbrev-commit --reverse origin/integration.. --name-only'
alias glpl='git log --pretty=oneline --abbrev-commit --reverse origin/linear..'
alias glr="git log -p --reverse origin/integration.."
alias glrw="git log --word-diff-regex='[[:alnum:]]+|[^[:space:]]' --color-words -p -w --reverse -M origin/integration.."
alias gf=git_fetch
alias grp=git_request_pull

# Vim - Git related aliases
alias vgdom='vim $(git diff origin/master --name-only)'
alias vgdoi='vim $(git diff origin/integration --name-only)'
alias vgd='vim $(git diff --name-only)'

# Python aliases
alias isvirtualenvactive='env | grep VIRTUAL_ENV | wc -l'
alias createvirtualenv='virtualenv env && source env/Scripts/activate'
alias setupvirtualenv='/c/work/setup_env.sh'

# Front end
alias buildall='rm -rf node_modules/ app/bower_components/ && npm install && bower install && bower update && grunt build test'

alias        ..='cd ..'
alias       ...='cd ../..'
alias      ....='cd ../../..'
alias     .....='cd ../../../..'
alias    ......='cd ../../../../..'
alias   .......='cd ../../../../../..'
alias  ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'

acksearch () {
    ack -A5 -B5 -i $1
}

function parse_git_branch
{
    if [ "$PWD" = "$HOME" ]; then
        echo ""
    else
        ref=$(git symbolic-ref HEAD 2> /dev/null) || return
        echo "${ref#refs/heads/} "
    fi
}

git_fetch () {
    git fetch $1
    git checkout FETCH_HEAD
    git rebase origin/integration
    rtk_incr_test.pl -b origin/integration
}

git_request_pull () {
    if [ $1 ]; then
        git request-pull $1 `hostname`:`pwd`
    else
        git request-pull origin/integration `hostname`:`pwd`
    fi
}
