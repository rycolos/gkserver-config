#! /bin/bash

user='ubuntu'

apt update
apt install git ansible -y
ansible-pull -e "user=$user" -U https://github.com/rycolos/gkserver-ansible.git local.yml