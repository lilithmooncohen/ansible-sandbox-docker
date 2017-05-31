# ansible-sandbox-docker

## Start Sandbox Host
```
git clone https://github.com/ryanckoch/ansible-sandbox-docker.git && \
cd ansible-sandbox-docker && \
./init.sh ubuntu_16.04 username password
```

## Add the following to your SSH config
```
Host 127.0.0.1.nip.io
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
```

## You should now be able to SSH to your host and in turn run ansible against it
```
ssh 127.0.0.1.nip.io
```