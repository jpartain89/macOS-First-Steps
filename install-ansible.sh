#!/bin/bash -e

# Installs Ansible and /etc/ansible files.

for uPYTHON in [python2.7, python3.5, python3.6]; do
    sudo chown -R jpartain89:staff "/usr/local/lib/$uPYTHON"
done

pip install --upgrade ansible || sudo -H pip install --upgrade ansible

if [[ ! -e /etc/ansible ]] && [[ -e /Volumes/8TB_EXT/shared/Tech/ansible ]]; then
    sudo mkdir /etc/ansible
    sudo cp /Volumes/8TB_EXT/shared/Tech/ansible/* /etc/ansible/
elif [[ ! -e /etc/ansible ]] && [[ ! -e /Volumes/8TB_EXT/shared/Tech/ansible ]]; then
    sudo mkdir /etc/ansible
    echo "localhost" | sudo tee /etc/ansible/hosts
    sudo wget -O /etc/ansible/ansible.cfg https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg
fi

/usr/local/bin/ansible-galaxy install -r requirements.yml
