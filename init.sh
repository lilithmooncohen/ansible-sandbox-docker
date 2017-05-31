#!/bin/bash

set -e

export ANSIBLE_SANDBOX_CONTAINER_NAME="ansible-sandbox"
export ANSIBLE_SANDBOX_HOST_PORT="2222"
export ANSIBLE_SANDBOX_USER_NAME="ryanckoch"
export ANSIBLE_SANDBOX_USER_PASSWD="testola123"
export ANSIBLE_SANDBOX_USER_KEY=$(<~/.ssh/authorized_keys)

cd $1
./init.sh
