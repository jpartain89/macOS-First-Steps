#!/bin/bash -e

# My attempt at automating my macOS setup.
# This file is meant to be downloaded direct, without git having already
# existing.

# TODO: First, need to make a unified "unix-first-steps"  git repo
# ENHANCEMENT: Add in Linux/Debian/Unix commands that are "global" for universal use
# TODO: For the linux_dotfiles, remove the "non-dotfiles" files from the repo

if [[ $(uname) == "Darwin" ]]; then
    USER_HOME="/Users/${USER}"
    GIT_DIR="$USER_HOME/git"
    FIRST_STEPS="$GIT_DIR/macos-first-steps"
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ -e "$(which allunix)" ]]; then ALLUNIX=$(which allunix); fi
    if [[ "$ALLUNIX" ]]; then . "$ALLUNIX"
    else
        echo ""
        echo "Sorry, but it looks like the AllUnix functions file is not installed on your system."
        echo "See github.com/jpartain89/myfunctions for more information."
        exit 1;
    fi

macos_pre () {
    if [[ $(xcode-select --install 2>/dev/null) == "1" ]] ; then
cat <<- EOF

    Looks like you already installed xcode's CLI stuff
    Press Enter to Continue...

EOF
        read -r
    fi
    if [[ $(comand -v brew) == "" ]]; then
        echo ""
        echo "Now installing HomeBrew."
        echo ""
        /usr/bin/ruby -e "$(curl -fsSL  https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
}

install_brew_apps () {
    echo ""
    echo "Now installing basic Homebrew Stuffs"
    /usr/local/bin/brew install git --with-brewed-curl --with-persistent-https
    /usr/local/bin/brew install rcmdnk/file/brew-file
}

dotfile_clone () {
    # Make sure git_loc exists
    if [[ ! -d "$GIT_DIR" ]]; then
        echo ""
        echo "Creating the git directory location"
        mkdir "$GIT_DIR" 2>/dev/null
    fi

    # Make sure the macos_dotfile repo is cloned
    if [[ ! -e "$GIT_DIR/dotfiles" ]]; then
        echo ""
        echo "Dotfiles git repo is not cloned locally, fixing."
        git clone https://jpartain89@github.com/jpartain89/dotfiles.git "$GIT_DIR/dotfiles"
        if [[ -x "${GIT_DIR}/dotfiles/linking" ]]; then
            echo ""
            echo "Running the linking script"
            bash -ex "${GIT_DIR}/dotfiles/linking"
        fi
    fi
}

macos_pre && install_brew_apps; dotfile_clone; bash ./git_bootstrap.sh
