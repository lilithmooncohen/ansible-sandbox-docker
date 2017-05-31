FROM ubuntu:16.04

ENV container="docker" \
    LC_ALL="C" \
    DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    bash \
    python \
    openssh-server \
    sudo \
    net-tools \
    systemd \
    iptables \
    && \
    rm -rf /tmp/* /var/lib/apt/lists/*

RUN cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    rm -f /lib/systemd/system/plymouth*; \
    rm -f /lib/systemd/system/systemd-update-utmp*;

RUN systemctl set-default multi-user.target

ENV init="/lib/systemd/systemd"

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT ["/lib/systemd/systemd"]

ENV DOCKER_CHANNEL="edge" \
    DOCKER_VERSION="17.05.0-ce"

RUN set -ex; \
# why we use "curl" instead of "wget":
# + wget -O docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-17.03.1-ce.tgz
# Connecting to download.docker.com (54.230.87.253:443)
# wget: error getting response: Connection reset by peer
	curl -fL -o docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz"; \
	tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	; \
	rm docker.tgz; \
	dockerd -v; \
	docker -v

# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
RUN set -x && \
    useradd -m -s /bin/bash dockremap && \
    echo 'dockremap:165536:65536' >> /etc/subuid && \
    echo 'dockremap:165536:65536' >> /etc/subgid && \
    groupadd docker

ENV DIND_COMMIT 3b5fac462d21ca164b3778647420016315289034

RUN set -ex; \
    wget -O /usr/local/bin/dind "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind"; \
    chmod +x /usr/local/bin/dind

COPY dockerd-entrypoint.sh /usr/local/bin/
COPY docker.service /etc/systemd/system/docker.service

VOLUME /var/lib/docker

ENV ROOT_PASSWD="wjgCZM8pSaVA9HtZ"
RUN mkdir /var/run/sshd && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    echo "root:$ROOT_PASSWD" |chpasswd

EXPOSE 22 2375

ARG ANSIBLE_SANDBOX_USER_NAME
ARG ANSIBLE_SANDBOX_USER_PASSWD
ARG ANSIBLE_SANDBOX_USER_KEY

RUN useradd -m -s /bin/bash ${ANSIBLE_SANDBOX_USER_NAME} && \
    usermod -aG sudo ${ANSIBLE_SANDBOX_USER_NAME} && \
    usermod -aG docker ${ANSIBLE_SANDBOX_USER_NAME} && \
    echo "${ANSIBLE_SANDBOX_USER_NAME}:${ANSIBLE_SANDBOX_USER_PASSWD}" |chpasswd && \
    mkdir /home/${ANSIBLE_SANDBOX_USER_NAME}/.ssh/ && \
    echo "${ANSIBLE_SANDBOX_USER_KEY}" > /home/${ANSIBLE_SANDBOX_USER_NAME}/.ssh/authorized_keys && \
    chown -R ${ANSIBLE_SANDBOX_USER_NAME}:${ANSIBLE_SANDBOX_USER_NAME} /home/${ANSIBLE_SANDBOX_USER_NAME}/.ssh && \
    chmod 600 /home/${ANSIBLE_SANDBOX_USER_NAME}/.ssh/authorized_keys
