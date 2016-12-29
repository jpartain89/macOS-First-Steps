#!/bin/bash -e

# JPartain89's Bootstrap File for macOS

user_home="/Users/$(logname)"
git_dir="$user_home/git"
dot_loc="$git_dir/macos_dotfiles"
user_owned="$(logname):staff"
root_owned="root:wheel"

# This is for sourcing myfunctions repo, or downloading if not there.
if [[ ! -e "$git_dir/myfunctions/allunix" ]]; then
    echo ""
    echo "Cloning the MyFunctions Git Repo"
    echo ""
    git clone https://jpartain89@github.com/jpartain89/myfunctions "$git_dir/myfunctions"
    sudo bash "$git_dir/myfunctions/install.sh"
fi

. /usr/local/bin/allunix

echo ""
echo "git pull origin master on macos_dotfiles"
echo ""
git -C "$dot_loc" pull origin master

doIt ()
    {
        ########## dotfiles ##########
        echo ""
        echo "Syncing dotfiles"
        sudo rsync -avhuPcOq --no-p --chmod=0755 --chown="$user_owned" "$dot_loc/dotfiles/" "$user_home/";

        ########## ssh ##########
        echo ""
        echo "Syncing .ssh/config"
        sudo rsync -avhuPcOq --no-p --chmod=0755 --chown="$user_owned" "$dot_loc/ssh/config" "$user_home/.ssh/"
        echo ""
        echo "Syncing /etc/ssh"
        # rsync over to /etc/ssh destination
        sudo rsync -avhuPcOq --no-p --chmod=0755 --chown="$root_owned" "$dot_loc/etc/ssh/" /etc/ssh/
        # rsync over to /usr/local/etc/ssh destination
        sudo rsync -avhuPcOq --no-p --chmod=0755 --chown="$root_owned" "$dot_loc/etc/ssh/" /usr/local/etc/ssh/

        ########## sudo ##########
        echo ""
        echo "Syncing sudoers"
        sudo rsync -avhuPcOq --no-p --chmod=0440 --chown="$root_owned" "$dot_loc/etc/sudoers" /etc/sudoers
        echo ""
        echo "Syncing sudoers.d"
        sudo rsync -avhuPcOq --no-p --chmod=0440 --chown="$root_owned" "$dot_loc/etc/sudoers.d/" /etc/sudoers.d/
        echo ""
        echo "Checking sudoers files"
        echo ""
        sudo visudo -c

        ########## apps ##########
        echo ""
        echo "Syncing apps"
        sudo rsync -avhuPcOq --no-p --chmod=0755 --chown="$user_owned" "$dot_loc/apps/" /usr/local/bin/

        ########## Paths ##########
        echo ""
        echo "Syncing paths"
        sudo rsync -avhuPcOq --no-p --chmod=0755 --chown="$root_owned" "$dot_loc/etc/paths" /etc/paths
        echo ""
        echo "Syncing paths.d"
        sudo rsync -avhuPcOq --no-p --chmod=0755 --chown="$root_owned" "$dot_loc/etc/paths.d/" /etc/paths.d/

        ########## BrewFile Linking ##########
        echo ""
        echo "Linking Brewfile"
        if [[ ! -e "$user_home/.brewfile" ]]; then
            mkdir "$user_home/.brewfile"
            sudo ln -s "$dot_loc/Brewfile" "$user_home/.brewfile/Brewfile"
        fi

        ########## Sourcing default dotfile ##########
        echo ""
        echo "Now sourcing .bash_profile"
        . "$user_home/.bash_profile"
}

no_sudo && doIt
