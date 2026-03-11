# Docker 数据迁移指南

## 环境信息

| 项目                 | 值                                                                                       |
| -------------------- | ---------------------------------------------------------------------------------------- |
| 操作系统             | Ubuntu 22.04                                                                             |
| 当前 Docker 数据目录 | `/var/lib/docker`（34G）                                                                 |
| 目标目录             | `/media/wht/N/docker`                                                                    |
| 运行中的容器         | tdengine-server, kibana, rabbitmq, elasticsearch, mysql, nginx, minio, redis, zlmediakit |

## 迁移步骤

### 1. 查看当前数据大小

```bash
sudo du -sh /var/lib/docker
```

### 2. 停止所有容器

```bash
docker stop $(docker ps -q)
```

### 3. 停止 Docker 服务

```bash
sudo systemctl stop docker
sudo systemctl stop docker.socket
```

### 4. 创建目标目录并复制数据

```bash
sudo mkdir -p /media/wht/N/docker
sudo rsync -avP /var/lib/docker/ /media/wht/N/docker/
```

> 注意：复制时间取决于数据量大小，请耐心等待

### 5. 修改 Docker 配置

```bash
sudo nano /etc/docker/daemon.json
```

将配置文件中的：
```json
"data-root": "/var/lib/docker"
```

修改为：
```json
"data-root": "/media/wht/N/docker"
```

### 6. 启动 Docker 服务

```bash
sudo systemctl start docker
```

### 7. 验证新路径

```bash
docker info | grep "Docker Root Dir"
```

确认输出为：`Docker Root Dir: /media/wht/N/docker`

### 8. 启动容器

```bash
docker start tdengine-server kibana rabbitmq elasticsearch mysql nginx minio redis zlmediakit
```

### 9. 清理旧数据（可选）

确认一切正常运行后，可删除旧数据释放空间：

```bash
sudo rm -rf /var/lib/docker
```

> ⚠️ 建议：确认新位置运行稳定几天后再执行此步骤

## 注意事项

1. **备份重要数据**：迁移前建议备份重要容器数据或镜像
2. **JSON 格式**：修改配置文件时确保 JSON 格式正确
3. **权限问题**：使用 `rsync -a` 保持文件权限和属性
4. **磁盘空间**：迁移过程中需要约 2 倍数据量的临时空间

---

## 硬盘挂载权限问题

### 问题描述

挂载的硬盘 `/media/wht/N` 没有操作权限，无法写入文件。

### 诊断步骤

```bash
# 查看挂载信息
mount | grep "/media/wht/N"

# 查看目录权限
ls -ld /media/wht/N

# 查看文件系统类型
df -Th /media/wht/N
```

### 问题原因

挂载硬盘的目录所有者为 **root**，当前用户只有读取和执行权限：

```
drwxr-xr-x 3 root root 4096  /media/wht/N
```

- 硬盘已以读写模式挂载（rw），但目录权限限制了普通用户的写入

### 解决方案

#### 方案一：修改目录所有者（推荐）

将目录所有者改为当前用户：

```bash
sudo chown -R wht:wht /media/wht/N
```

#### 方案二：修改目录权限

允许所有用户读写：

```bash
sudo chmod -R 777 /media/wht/N
```

> 说明：方案一更安全，仅赋予当前用户权限；方案二适合需要多用户共享的场景
