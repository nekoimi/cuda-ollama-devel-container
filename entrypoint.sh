#!/usr/bin/env bash

### 修改root密码
echo "root:$ROOT_PASSWORD" | chpasswd

### 启动ssh
service sshd start

### 启动docker
service docker start