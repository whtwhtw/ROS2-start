# ROS 2 Humble Docker 开发环境配置指南

## 环境信息

| 项目 | 值 |
|------|-----|
| 操作系统 | Ubuntu 22.04 |
| Docker 镜像 | osrf/ros:humble-desktop-full |
| ROS 版本 | ROS 2 Humble Hawksbill |
| 工作空间 | /media/wht/L/ROS/ros2_ws |

## 一、镜像拉取

```bash
docker pull osrf/ros:humble-desktop-full
```

## 二、创建容器

### 2.1 启用 X11 转发

```bash
xhost +local:docker
```

### 2.2 创建并启动容器

```bash
docker run -d \
  --name ros2-humble \
  --privileged \
  -e DISPLAY=$DISPLAY \
  -e QT_X11_NO_MITSHM=1 \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /media/wht/L/ROS/ros2_ws:/root/ros2_ws \
  -v ~/.ssh:/root/.ssh:ro \
  -w /root/ros2_ws \
  osrf/ros:humble-desktop-full \
  tail -f /dev/null
```

**参数说明：**
- `--privileged`：授予容器特权模式，支持硬件访问
- `-e DISPLAY`：传递显示环境变量
- `-v /tmp/.X11-unix`：挂载 X11 socket 实现可视化
- `-v ros2_ws`：挂载工作空间目录

## 三、项目结构

```
/media/wht/L/ROS/
├── .devcontainer/
│   └── devcontainer.json    # Dev Container 配置
├── .vscode/
│   ├── launch.json          # 调试配置
│   ├── tasks.json           # 任务配置
│   └── settings.json        # 工作区设置
├── ros2_ws/
│   └── src/
│       └── example_pkg/     # 示例包
│           └── example_pkg/
│               ├── talker.py   # 发布者节点
│               └── listener.py # 订阅者节点
├── ros2_docker.sh           # 容器管理脚本
└── ros2_humble_setup_guide.md
```

## 四、使用方法

### 方式一：管理脚本（推荐）

```bash
# 进入工作目录
cd /media/wht/L/ROS

# 启动容器
./ros2_docker.sh start

# 编译项目
./ros2_docker.sh build

# 运行示例节点
./ros2_docker.sh run

# 启动发布者节点（终端1）
./ros2_docker.sh talker

# 启动订阅者节点（终端2）
./ros2_docker.sh listener

# 进入容器交互
./ros2_docker.sh shell

# 停止容器
./ros2_docker.sh stop

# 删除容器
./ros2_docker.sh rm
```

### 方式二：VSCode 调试

1. 用 VSCode 打开文件夹 `/media/wht/L/ROS`
2. 按 `F5` 启动调试
3. 选择调试配置：
   - **Debug Talker (Python)**：调试发布者节点
   - **Debug Listener (Python)**：调试订阅者节点
   - **Attach to Docker Container**：附加到容器调试
4. 在代码行号左侧点击设置断点

### 方式三：Dev Container

1. 安装 VSCode 扩展：`Dev Containers`
2. 按 `Ctrl+Shift+P` → 输入 `Dev Containers: Reopen in Container`
3. 自动进入容器环境，可直接开发调试

## 五、常用命令

### 5.1 容器管理

```bash
# 查看容器状态
docker ps -a | grep ros2-humble

# 启动容器
docker start ros2-humble

# 停止容器
docker stop ros2-humble

# 进入容器
docker exec -it ros2-humble bash
```

### 5.2 编译与运行

```bash
# 编译工作空间
docker exec ros2-humble bash -c "source /opt/ros/humble/setup.bash && cd /root/ros2_ws && colcon build --symlink-install"

# 运行 Talker 节点
docker exec -it ros2-humble bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/setup.bash && ros2 run example_pkg talker"

# 运行 Listener 节点（另开终端）
docker exec -it ros2-humble bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/setup.bash && ros2 run example_pkg listener"
```

### 5.3 可视化工具

```bash
# 启动 RViz2
docker exec ros2-humble bash -c "source /opt/ros/humble/setup.bash && rviz2"

# 启动 rqt
docker exec ros2-humble bash -c "source /opt/ros/humble/setup.bash && rqt"

# 启动 Gazebo
docker exec ros2-humble bash -c "source /opt/ros/humble/setup.bash && gazebo"
```

### 5.4 ROS 2 常用命令

```bash
# 进入容器
docker exec -it ros2-humble bash
source /opt/ros/humble/setup.bash

# 查看话题列表
ros2 topic list

# 查看话题信息
ros2 topic echo /chatter

# 查看节点列表
ros2 node list

# 查看服务列表
ros2 service list

# 查看参数
ros2 param list
```

## 六、VSCode 任务配置

通过 `Ctrl+Shift+P` → `Tasks: Run Task` 运行：

| 任务名称 | 说明 |
|---------|------|
| build-ros2 | 编译 ROS2 工作空间 |
| run-talker | 运行 Talker 发布者节点 |
| run-listener | 运行 Listener 订阅者节点 |
| run-rviz2 | 启动 RViz2 可视化工具 |

## 七、调试配置说明

### launch.json 配置项

```json
{
    "name": "Debug Talker (Python)",
    "type": "debugpy",
    "request": "launch",
    "program": "${workspaceFolder}/ros2_ws/src/example_pkg/example_pkg/talker.py",
    "env": {
        "PYTHONPATH": "/opt/ros/humble/lib/python3.10/site-packages",
        "AMENT_PREFIX_PATH": "/opt/ros/humble",
        "ROS_DISTRO": "humble"
    }
}
```

### 调试步骤

1. 打开 `talker.py` 或 `listener.py`
2. 在需要调试的行号左侧点击设置断点（红点）
3. 按 `F5` 启动调试
4. 使用调试工具栏：
   - `F5` - 继续执行
   - `F10` - 单步跳过
   - `F11` - 单步进入
   - `Shift+F11` - 单步跳出
   - `Shift+F5` - 停止调试

## 八、示例节点说明

### Talker 发布者节点

```python
# 发布 "Hello ROS2 Humble! Count: N" 消息到 /chatter 话题
# 频率：2Hz（每0.5秒发布一次）
```

### Listener 订阅者节点

```python
# 订阅 /chatter 话题
# 收到消息后打印到日志
```

## 九、常见问题

### 9.1 可视化无法显示

```bash
# 检查 X11 转发
echo $DISPLAY

# 重新启用 X11 转发
xhost +local:docker

# 检查 X11 socket
ls -la /tmp/.X11-unix/
```

### 9.2 权限问题

```bash
# 修改工作空间权限
sudo chown -R $USER:$USER /media/wht/L/ROS/ros2_ws
```

### 9.3 编译问题

```bash
# 清理编译缓存
docker exec ros2-humble bash -c "cd /root/ros2_ws && rm -rf build install log"

# 重新编译
docker exec ros2-humble bash -c "source /opt/ros/humble/setup.bash && cd /root/ros2_ws && colcon build --symlink-install"
```

### 9.4 容器启动失败

```bash
# 查看容器日志
docker logs ros2-humble

# 删除旧容器重新创建
docker rm -f ros2-humble
# 然后重新执行创建命令
```

## 十、扩展开发

### 创建新的 ROS 2 包

```bash
# Python 包
docker exec ros2-humble bash -c "source /opt/ros/humble/setup.bash && cd /root/ros2_ws/src && ros2 pkg create --build-type ament_python my_pkg"

# C++ 包
docker exec ros2-humble bash -c "source /opt/ros/humble/setup.bash && cd /root/ros2_ws/src && ros2 pkg create --build-type ament_cmake my_pkg --dependencies rclcpp std_msgs"
```

### 安装额外依赖

```bash
# 进入容器
docker exec -it ros2-humble bash

# 安装 ROS 2 包
apt update && apt install -y ros-humble-navigation2 ros-humble-nav2-bringup

# 安装 Python 包
pip3 install numpy scipy matplotlib
```

---

## 快速参考

| 操作 | 命令 |
|------|------|
| 启动容器 | `./ros2_docker.sh start` |
| 编译项目 | `./ros2_docker.sh build` |
| 进入容器 | `./ros2_docker.sh shell` |
| 运行示例 | `./ros2_docker.sh run` |
| 发布者节点 | `./ros2_docker.sh talker` |
| 订阅者节点 | `./ros2_docker.sh listener` |
| 启动 RViz2 | VSCode 任务 → `run-rviz2` |
| VSCode 调试 | 按 `F5` |
