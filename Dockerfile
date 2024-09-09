FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

LABEL maintainer="nekoimi <nekoimime@gmail.com>"

ARG WORKHOME=/workspace

ENV ROOT_PASSWORD=password
ENV TZ=Asia/Shanghai
ENV LANG=en_US.UTF-8

WORKDIR $WORKHOME

COPY entrypoint.sh  /entrypoint.sh
COPY ollama.service /etc/systemd/system/ollama.service

RUN set -ex && \
    apt update && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    yes | unminimize && \
    apt install -y systemd sudo bash-completion zsh git git-lfs ca-certificates curl vim unzip gcc g++ make htop tcpdump lsof telnet net-tools dnsutils iputils-ping nfs-common && \
    git lfs install && \
    systemctl mask systemd-resolved.service && \
    echo "LANG=$LANG" > /etc/default/locale && \
    chmod +x /entrypoint.sh

## 安装ssh
RUN set -ex && \
    apt install -y openssh-server && \
    sed -i 's@#Port 22@Port 22@g' /etc/ssh/sshd_config && \
    sed -i 's@#ListenAddress 0.0.0.0@ListenAddress 0.0.0.0@g' /etc/ssh/sshd_config && \
    sed -i 's@#PermitRootLogin prohibit-password@PermitRootLogin yes@g' /etc/ssh/sshd_config && \
    systemctl enable sshd

# 安装docker
RUN set -ex && \
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove $pkg; done && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    systemctl enable docker

# 安装ollama
RUN set -ex && \
    curl -L https://ollama.com/download/ollama-linux-amd64.tgz -o ollama-linux-amd64.tgz && \
    tar -C /usr -xzf ollama-linux-amd64.tgz && \
    useradd -r -s /bin/false -U -m -d /usr/share/ollama ollama && \
    usermod -a -G ollama $(whoami) && \
    systemctl enable ollama && \
    ollama -v

VOLUME $WORKHOME

# 暴露端口
EXPOSE 22 11434

# 初始化
ENTRYPOINT ["/entrypoint.sh"]

CMD ["systemd"]