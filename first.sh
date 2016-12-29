#!/bin/bash -e

# My attempt at automating my macOS setup.
# This file is meant to be downloaded direct, without git having already
# existing.

home_dir="/Users/$(logname)"
git_dir="$home_dir/git"
dot_loc="$git_dir/macos_dotfiles"

install_xcode () {
    if [[ $(sudo xcode-select --install 2>/dev/null) == "1" ]] ; then
        echo ""
        echo "Looks like you already installed xcode's CLI stuff"
        echo "Press Enter to Continue..."
        echo ""
        read -r
    fi
}

install_homebrew () {
    if [[ $(which -s brew) == "1" ]]; then
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

macos_dotfile_clone () {
    # Make sure git_loc exists
    if [[ ! -e "$git_dir" ]]; then
        echo ""
        echo "Creating the git directory location"
        mkdir "$git_dir"
    fi

    # Make sure the macos_dotfile repo is cloned
    if [[ ! -e "$dot_loc" ]]; then
        echo ""
        echo "MacOS Dotfiles git repo is not cloned locally, fixing."
        git clone https://jpartain89@github.com/jpartain89/macos_dotfiles.git "$dot_loc"
    fi
}

install_pip_stuff () {
    for iPIP in [pip, pip3]; do
        sudo -H "$iPIP" install --upgrade pip setuptools wheel
    done
}

install_xcode; install_homebrew; install_brew_apps; macos_dotfile_clone; install_pip_stuff; bash ./git_bootstrap.sh
