#!/bin/bash -e

# My attempt at automating my macOS setup.
# This file is meant to be downloaded direct, without git having already
# existing.

# TODO: First, need to make a unified "unix-first-steps"  git repo
# ENHANCEMENT: Add in Linux/Debian/Unix commands that are "global" for universal use
# TODO: For the linux_dotfiles, remove the "non-dotfiles" files from the repo

if [[ $(uname) == "Darwin" ]]; then
    USER_HOME=/Users/jpartain89
    GIT_DIR="$USER_HOME/git"
    FIRST_STEPS="$GIT_DIR/macos-first-steps"
fi

WORKDIR=$(pwd)
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
        echo ""
        echo "Looks like you already installed xcode's CLI stuff"
        echo "Press Enter to Continue..."
        echo ""
        read -r
    fi
    if [[ $(which brew) == "" ]]; then
        echo ""
        echo "Homebrew is not installed yet. Fixing that"
        echo ""
        /usr/bin/ruby -e "$(curl -fsSL  https://raw.githubusercontent.com/Homebrew/install/master/install)"
        echo "Running brew doctor"
         /usr/local/bin/brew doctor
        echo "Press Enter to Continue "
        read -r
        echo "Running brew update"
        /usr/local/bin/brew update
        echo "Press Enter to Continue"
        read -r
    fi
}

install_brew_apps () {
    echo ""
    echo "Now installing basic Homebrew Stuffs"
    /usr/local/bin/brew install git --with-brewed-curl --with-persistent-https
    /usr/local/bin/brew install python --with-sphinx-doc
    /usr/local/bin/brew install python3 --with-sphinx-doc
    /usr/local/bin/brew tap rcmdnk/file
    /usr/local/bin/brew install rcmdnk/file/brew-file
}

install_git_apps () {
    if [[ $(which -s git) == "1" ]]; then
        echo ""
        echo "Git is not installed."
        echo "Probably a lot other items missing."
        echo "Fixing."
        echo ""
        sudo apt-get install git git-core python python-pip make apt-transport-https libffi-dev libssl-dev zlib1g-dev libxslt1-dev libxml2-dev python-dev build-essential python2.7 python3.5 python3.5-pip python-setuptools unzip
    fi
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
    fi

    for iPIP in pip pip3 pip3.5 pip3.6;
    do
        sudo -H "$iPIP" install --upgrade pip setuptools wheel
        sudo -H "$iPIP" install --upgrade -r "$FIRST_STEPS/requirements.txt"
    done
}

macos_pre && install_brew_apps; dotfile_clone; bash ./git_bootstrap.sh
