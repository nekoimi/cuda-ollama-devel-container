#!/usr/bin/env bash

### 修改root密码
echo "root:$ROOT_PASSWORD" | chpasswd

### 启动ssh
systemctl start sshd

### 启动docker
systemctl start docker