#!/bin/bash
cd $4 || cd .
ANSIBLE_CONFIG=ansible/ansible.cfg \
ANSIBLE_LOAD_CALLBACK_PLUGINS=true \
ANSIBLE_STDOUT_CALLBACK=json \
ansible "${1}" \
-i "${2}"/ \
-m debug \
-a "msg={{ ${3} | to_json }}" \
| jq -r --arg host "${1}" '.plays[0] | .tasks[0] | .hosts | .[$host] | .msg'