#!/bin/bash -e

# This is meant to be strictly for making sure the basic git repos are
# downloaded for kicking off my macOS fresh install.

user_home="/Users/$(logname)"
git_dir="$user_home/git"
dot_loc="$git_dir/macos_dotfiles"

# This is for sourcing myfunctions repo, or downloading if not there.
if [[ ! -e "$git_dir/myfunctions/allunix" ]]; then
    echo ""
    echo "Cloning the MyFunctions Git Repo"
    echo ""
    git clone https://jpartain89@github.com/jpartain89/myfunctions "$git_dir/myfunctions"
    echo "Installing the allunix file"
    echo ""
    sudo bash "$git_dir/myfunctions/install.sh"
fi

if [[ -e /usr/local/bin/allunix ]]; then
    . /usr/local/bin/allunix
else
    . "$git_dir/myfunctions/allunix"
fi

no_sudo

if_else ()
    {
        if [[ ! -e /usr/local/bin/map-pull-sub ]]; then
            echo ""
            echo "Downloading map-pull-sub"
            echo ""
            cd "$dot_loc"
            curl -L https://raw.githubusercontent.com/jpartain89/map-pull-sub/master/map-pull-sub | bash
        fi

        # Install iTerm Scripts
        if [[ ! -e "/Users/$(logname)/.iterm2_shell_integration.bash" ]]; then
            curl -L https://iterm2.com/misc/install_shell_integration_and_utilities.sh | bash
        fi
    }

if_else
