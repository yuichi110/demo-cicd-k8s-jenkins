#!/bin/bash

if [ $# -ne 1 ]; then
  echo 'Please provide target host name/ip'
  exit 1
fi

dir_path=$(cd $(dirname $0); pwd)
ansible-playbook -i $1, -u ubuntu --ask-become-pass ./ansible_playbook.yml 