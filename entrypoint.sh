#!/usr/bin/env bash

### 修改root密码
echo "root:$ROOT_PASSWORD" | chpasswd

### 启动ssh
service ssh start

### 执行CMD参数
exec "$@"
