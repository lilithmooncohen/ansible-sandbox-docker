#!/bin/bash

set -e

ANSIBLE_SANDBOX_IMAGE="ansible-sandbox-ubuntu16"

docker build -t ${ANSIBLE_SANDBOX_IMAGE} --build-arg ANSIBLE_SANDBOX_USER_NAME="${ANSIBLE_SANDBOX_USER_NAME}" --build-arg ANSIBLE_SANDBOX_USER_PASSWD="${ANSIBLE_SANDBOX_USER_PASSWD}" --build-arg ANSIBLE_SANDBOX_USER_KEY="${ANSIBLE_SANDBOX_USER_KEY}" .
docker rm -f ${ANSIBLE_SANDBOX_CONTAINER_NAME} || true
docker run -d --name ${ANSIBLE_SANDBOX_CONTAINER_NAME} --hostname ${ANSIBLE_SANDBOX_IMAGE} --restart=always --privileged=true -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p ${ANSIBLE_SANDBOX_HOST_PORT}:22 ${ANSIBLE_SANDBOX_IMAGE}
docker exec -it ${ANSIBLE_SANDBOX_CONTAINER_NAME} /bin/bash -c "systemctl start sshd"
docker exec -it ${ANSIBLE_SANDBOX_CONTAINER_NAME} /bin/bash -c "systemctl start docker"