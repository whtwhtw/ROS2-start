# Git 操作指南

本文档记录了将 ROS2 项目上传到 GitHub 远程仓库的操作步骤。

## 目标仓库

- 远程地址：`git@github.com:whtwhtw/ROS2-start.git`

## 操作步骤

### 1. 创建 .gitignore 文件

排除不需要版本控制的文件：

```gitignore
# ROS2 build artifacts
build/
install/
log/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
*.egg-info/
.eggs/
*.egg

# IDE
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Docker
*.log
```

### 2. 初始化 Git 仓库

```bash
# 初始化仓库
git init

# 将默认分支重命名为 main
git branch -m main
```

### 3. 添加远程仓库

```bash
git remote add origin git@github.com:whtwhtw/ROS2-start.git
```

### 4. 添加文件到暂存区

```bash
git add .
```

### 5. 首次提交

```bash
git commit -m "Initial commit: ROS2 workspace setup with Docker support"
```

### 6. 拉取远程仓库内容（合并历史）

如果远程仓库已有内容（如 README.md），需要先拉取并合并：

```bash
git pull origin main --allow-unrelated-histories --no-rebase
```

### 7. 推送到远程仓库

```bash
git push -u origin main
```

## 后续操作：上传 build/install/log 目录

如果需要将编译产物也加入版本控制：

### 1. 修改 .gitignore

移除或注释掉以下行：
```gitignore
# build/
# install/
# log/
```

### 2. 添加并提交变更

```bash
git add .
git commit -m "Add build, install, log directories to repository"
git push
```

## 常用 Git 命令

```bash
# 查看状态
git status

# 查看远程仓库配置
git remote -v

# 查看提交历史
git log --oneline

# 拉取最新代码
git pull

# 推送代码
git push
```

## 注意事项

1. 确保已配置 SSH 密钥并添加到 GitHub 账户
2. 首次推送前，如果远程仓库有内容，必须先拉取合并
3. `build/`、`install/`、`log/` 目录通常不建议加入版本控制，除非有特殊需求
