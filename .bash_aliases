#! /usr/bin/bash

alias la='ls -alh --color=tty'
alias ls='ls -alh --color=tty'
alias ack5=acksearch
alias directorysize='du -h --max-depth=1 | sort -h'
alias tls='tmux list-sessions'
alias xit='exit'

alias gs='git status'
#alias gu='git remote update && git rebase origin/master && git submodule update'
alias gu='git-update-tree'
alias gsu='git submodule update'
alias gco='git checkout'
alias gdom='git diff origin/master'
alias gdomno='git diff origin/master --name-only'
alias vgdomno='vim $(git diff origin/master --name-only)'
alias gruom='git remote update origin/master'
alias gl='git log'
alias glno='git log --name-only'
alias glr="git log --word-diff-regex='[[:alnum:]]+|[^[:space:]]' --color-words -p -w --reverse -M origin/master.."
alias gf=git_fetch

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
    git rebase origin/master
    rtk_incr_test.pl -b master
}
