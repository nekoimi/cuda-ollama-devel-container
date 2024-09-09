#!/usr/bin/env bash

### 切换国内源
echo '切换国内源...'
cp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

deb https://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
deb-src https://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
EOF

### 修改root密码
echo "root:$ROOT_PASSWORD" | chpasswd

### 启动ssh
echo '启动ssh...'
service ssh start

### 启动docker
echo '启动docker...'
service docker start

### 执行CMD参数
exec "$@"
