#!/usr/bin/env bash

echo 'Running'

cd ansible
ansible-playbook -i hosts deploy.yml --sudo
# will add recipe