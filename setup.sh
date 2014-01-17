#!/usr/bin/env bash
# bootstrap installs things.

DOTFILES_ROOT="$HOME/.dotfiles"

set -e

show_help () { cat <<HELP
Usage: $(basename "$0")

See the Getting Started for documentation:
https://github.com/thcipriani/dotfile-boilerplate/blob/master/docs/getting_started.md

Copyright (c) 2013 Tyler H.T. Cipriani
Licensed under the MIT license.
https://github.com/thcipriani/dotfile-boilerplate/blob/master/LICENSE
HELP
exit;
}

info () {
    printf "\r[ \033[00;34m..\033[0m ] $1\n"
}

user () {
    printf "\r[ \033[0;33m?\033[0m ] $1 "
}

success () {
    printf "\r\033[2K[ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
    printf "\r\033[2K[\033[0;31mFAIL\033[0m] $1\n"
    echo
    exit
}

link_files () {
    ln -s "$1" "$2"
    success "linked $1 to $2"
}

prompt_shell () {
    user "Could not detect shell type (or shell type wasn't bash or zsh). What do you want to do? [S]kip shell dotfiles, assume [b]ash dotfiles, assume [z]sh dotfiles?"
    read shelltype
    case "$shelltype" in
        b )
            SHELL='bash';;
        z )
            SHELL='zsh';;
        * )
            SHELL='';;
    esac
}


check_shell () {
    if [[ -n "$SHELL" ]]; then
        SHELL=$(basename "$SHELL");
        if [[ "$SHELL" != "bash" && "$SHELL" != "zsh" ]]; then
            prompt_shell
        fi
    elif [[ -n "$MYSHELL" ]]; then
        SHELL=$(basename "$MYSHELL");
        if [[ "$SHELL" != "bash" && "$SHELL" != "zsh" ]]; then
            prompt_shell
        fi
    else
        SHELL_PATH=$(grep `whoami` /etc/passwd | cut -d ':' -f 7)
        SHELL=$(basename "$SHELL_PATH")
        if [[ -z "$SHELL" ]] || [[ "$SHELL" != "zsh" && "$SHELL" != "bash" ]]; then
            prompt_shell
        fi
    fi

    install_dotfiles
}

install_dotfiles () {
    info 'Installing dotfiles'

    files=$(find "$DOTFILES_ROOT" -mindepth 1 -maxdepth 1 -print | grep -v ".git/" | grep -v ".git$" | grep -v ".DS_Store" | grep -v "setup.sh" | grep -v "README.md")

    overwrite_all=false
    backup_all=false
    skip_all=false

    for source in $files; do
        file_base=${source#$DOTFILES_ROOT/}
        dest="$HOME/$file_base"

# echo "file_base=$file_base"
# echo "file_base2=$file_base2"
# echo "source=$source"
# echo "dest=$dest"

        if [ -h "$dest" ] && [ $(readlink "$dest") = $source ]; then
            continue;
        fi

        if [ -f "$dest" ] || [ -d "$dest" ]; then

            overwrite=false
            backup=false
            skip=false

            if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ] && [ "$overwrite" == "false" ]; then
                user "File already exists: $(basename "$dest"), what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
                read action

                case "$action" in
                    o )
                        overwrite=true;;
                    O )
                        overwrite_all=true;;
                    b )
                        backup=true;;
                    B )
                        backup_all=true;;
                    s )
                        skip=true;;
                    S )
                        skip_all=true;;
                    * )
                        ;;
                esac
            fi

            if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]; then
                rm -rf "$dest"
                success "removed $dest"
            fi

            if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]; then
                mv "$dest" "$dest"\.backup
                success "moved $dest to $dest.backup"
            fi

            if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]; then
                link_files "$source" "$dest"
            else
                success "skipped $source"
            fi

        else
            link_files "$source" "$dest"
        fi

    done

    info "All done. Restart your shell and enjoy!"
}

framework_check () {
    install_dotfiles
}

if [[ "$1" != '' ]]; then
    case "$1" in
        "--help"|"-h" )
            show_help
            ;;
        * )
            echo -e "Unknown option: $1\n"
            show_help
            ;;
    esac

fi

echo

# Initialize
check_shell

echo
echo 'All installed!'
