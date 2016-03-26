#!/usr/bin/env bash

echo 'Running'

cd solutions
echo 'vagrant up'
vagrant up

cd ansible
ansible-playbook -i hosts deploy.yml --sudo
# will add recipe