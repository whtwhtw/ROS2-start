# VSCode 可视化开发 ROS2 指南

本文档介绍使用 VSCode 进行 ROS2 Humble 可视化开发的完整流程。

## 前置条件

- 已拉取镜像：`osrf/ros:humble-desktop-full`
- 已安装 VSCode
- 已安装 Docker

---

## 方式一：Dev Container（推荐）

Dev Container 让 VSCode 在 Docker 容器内运行，提供最完整的开发体验。

### 安装扩展

在 VSCode 中安装以下扩展：

```bash
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-python.python
code --install-extension ms-python.debugpy
code --install-extension ms-iot.vscode-ros
```

### 使用步骤

1. 用 VSCode 打开项目文件夹：
   ```bash
   code /media/wht/N/ROS
   ```

2. 按 `Ctrl+Shift+P` 打开命令面板

3. 输入 `Dev Containers: Reopen in Container` 并回车

4. 等待容器构建完成（首次可能需要几分钟）

5. VSCode 左下角会显示绿色 "Dev Container: ROS 2 Humble Development"

### Dev Container 优势

| 特性 | 说明 |
|------|------|
| 自动补全 | 完整识别 ROS2 API，支持智能提示 |
| 代码跳转 | 可跳转到 ROS2 源码定义 |
| 调试支持 | 直接在容器内调试 Python/C++ 节点 |
| 集成终端 | 终端自动在容器环境运行 |
| 文件同步 | 本地文件自动映射到容器 |

### Dev Container 配置说明

配置文件：`.devcontainer/devcontainer.json`

```json
{
    "name": "ROS 2 Humble Development",
    "image": "osrf/ros:humble-desktop-full",
    "extensions": [
        "ms-python.python",
        "ms-python.debugpy",
        "ms-iot.vscode-ros"
    ],
    "mounts": [
        "source=/tmp/.X11-unix,target=/tmp/.X11-unix,type=bind",
        "source=${localWorkspaceFolder}/ros2_ws,target=/root/ros2_ws,type=bind"
    ],
    "environment": {
        "DISPLAY": "${localEnv:DISPLAY}",
        "QT_X11_NO_MITSHM": "1"
    },
    "runArgs": ["--privileged"]
}
```

---

## 方式二：本地 VSCode + Docker 容器

在宿主机运行 VSCode，通过 Docker 命令连接到容器。

### 安装扩展

```bash
code --install-extension ms-python.python
code --install-extension ms-python.debugpy
code --install-extension ms-iot.vscode-ros
code --install-extension ms-azuretools.vscode-docker
```

### 使用步骤

#### 1. 启动容器

```bash
cd /media/wht/N/ROS
./ros2_docker.sh start
```

#### 2. 编译项目

```bash
./ros2_docker.sh build
```

#### 3. 用 VSCode 打开项目

```bash
code /media/wht/N/ROS
```

#### 4. 运行任务

按 `Ctrl+Shift+P` → 输入 `Tasks: Run Task` → 选择任务：

| 任务名称 | 说明 |
|---------|------|
| `build-ros2` | 编译 ROS2 工作空间 |
| `run-talker` | 运行 Talker 发布者节点 |
| `run-listener` | 运行 Listener 订阅者节点 |
| `run-rviz2` | 启动 RViz2 可视化工具 |
| `run-rqt` | 启动 rqt 图形化工具 |
| `run-gazebo` | 启动 Gazebo 仿真器 |
| `start-container` | 启动 Docker 容器 |
| `stop-container` | 停止 Docker 容器 |

#### 5. 调试节点

1. 打开 Python 节点文件，如 `ros2_ws/src/example_pkg/example_pkg/talker.py`

2. 在需要调试的行号左侧点击，设置**断点**（红点）

3. 按 `F5` 启动调试

4. 选择调试配置：
   - **Debug Talker (Python)**：调试发布者节点
   - **Debug Listener (Python)**：调试订阅者节点

5. 使用调试工具栏：
   | 快捷键 | 功能 |
   |--------|------|
   | `F5` | 继续执行 |
   | `F10` | 单步跳过 |
   | `F11` | 单步进入 |
   | `Shift+F11` | 单步跳出 |
   | `Shift+F5` | 停止调试 |

#### 6. 调试变量监视

调试时可在 **监视面板** 添加表达式，实时查看变量值：
- 点击左侧调试图标
- 在 "监视" 区域点击 `+`
- 输入变量名或表达式

### 任务配置说明

配置文件：`.vscode/tasks.json`

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "build-ros2",
            "type": "shell",
            "command": "docker exec ros2-humble bash -c \"source /opt/ros/humble/setup.bash && cd /root/ros2_ws && colcon build --symlink-install\"",
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}
```

### 调试配置说明

配置文件：`.vscode/launch.json`

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug Talker (Python)",
            "type": "debugpy",
            "request": "launch",
            "program": "${workspaceFolder}/ros2_ws/src/example_pkg/example_pkg/talker.py",
            "console": "integratedTerminal",
            "env": {
                "PYTHONPATH": "/opt/ros/humble/lib/python3.10/site-packages",
                "ROS_DISTRO": "humble"
            }
        }
    ]
}
```

---

## 方式三：可视化工具集成

ROS2 提供多种可视化工具，支持图形化调试和分析。

### RViz2 - 机器人可视化

RViz2 用于可视化机器人模型、传感器数据、规划路径等。

#### 启动方式

**命令行：**
```bash
xhost +local:docker
docker exec ros2-humble bash -c "source /opt/ros/humble/setup.bash && rviz2"
```

**VSCode 任务：**
- 按 `Ctrl+Shift+P` → `Tasks: Run Task` → `run-rviz2`

#### 常用功能

| 功能 | 快捷键 |
|------|--------|
| 添加显示项 | `Add` 按钮 |
| 2D 导航 | 鼠标左键拖拽 |
| 3D 旋转 | `Shift` + 鼠标左键 |
| 缩放 | 滚轮 |
| 重置视角 | `r` 键 |

#### 配置保存

配置后的 RViz 布局可保存为 `.rviz` 文件：
```
File → Save Config As → my_config.rviz
```

### rqt - 图形化调试工具

rqt 是模块化的 ROS 工具平台，提供插件化的调试功能。

#### 启动方式

**命令行：**
```bash
xhost +local:docker
docker exec ros2-humble bash -c "source /opt/ros/humble/setup.bash && rqt"
```

**VSCode 任务：**
- 按 `Ctrl+Shift+P` → `Tasks: Run Task` → `run-rqt`

#### 常用插件

| 插件 | 功能 |
|------|------|
| **rqt_graph** | 查看节点和话题关系图 |
| **rqt_plot** | 实时绘制话题数据曲线 |
| **rqt_console** | 查看日志输出 |
| **rqt_image_view** | 显示图像话题 |
| **rqt_reconfigure** | 动态参数调整 |
| **rqt_service_caller** | 调用服务 |
| **rqt_topic_monitor** | 监控话题消息 |

#### 安装额外插件

```bash
docker exec -it ros2-humble bash
apt update
apt install -y ros-humble-rqt-*
```

### Gazebo - 仿真环境

Gazebo 提供物理仿真环境，用于机器人仿真测试。

#### 启动方式

**命令行：**
```bash
xhost +local:docker
docker exec ros2-humble bash -c "source /opt/ros/humble/setup.bash && gazebo"
```

**VSCode 任务：**
- 按 `Ctrl+Shift+P` → `Tasks: Run Task` → `run-gazebo`

#### 常用操作

| 操作 | 方法 |
|------|------|
| 插入模型 | 左侧面板 → Insert → 选择模型 |
| 旋转视角 | 鼠标左键拖拽 |
| 平移视角 | `Shift` + 鼠标左键 |
| 缩放 | 滚轮 |

---

## 项目结构

```
/media/wht/N/ROS/
├── .devcontainer/
│   └── devcontainer.json       # Dev Container 配置
├── .vscode/
│   ├── launch.json             # 调试配置
│   ├── tasks.json              # 任务配置
│   └── settings.json           # 工作区设置
├── ros2_ws/
│   ├── src/
│   │   └── example_pkg/        # 示例包
│   │       └── example_pkg/
│   │           ├── talker.py   # 发布者节点
│   │           └── listener.py # 订阅者节点
│   ├── build/                  # 编译输出
│   ├── install/                # 安装输出
│   └── log/                    # 日志输出
├── ros2_docker.sh              # 容器管理脚本
├── ros2_humble_setup_guide.md  # 环境配置指南
└── code-dev.md                 # 本文档
```

---

## 开发工作流

### 典型开发流程

```bash
# 1. 启动容器
cd /media/wht/N/ROS
./ros2_docker.sh start

# 2. 打开 VSCode
code /media/wht/N/ROS

# 3. （如果使用 Dev Container）
#    按 Ctrl+Shift+P → Dev Containers: Reopen in Container

# 4. 创建新包
docker exec ros2-humble bash -c "source /opt/ros/humble/setup.bash && cd /root/ros2_ws/src && ros2 pkg create --build-type ament_python my_pkg"

# 5. 编写代码
#    在 ros2_ws/src/my_pkg/ 中编写节点

# 6. 编译
#    VSCode 任务：build-ros2
#    或命令行：./ros2_docker.sh build

# 7. 调试
#    按 F5 → 选择调试配置

# 8. 可视化
#    VSCode 任务：run-rviz2 / run-rqt / run-gazebo
```

### 多终端开发

VSCode 支持多终端，方便同时运行多个节点：

1. 按 `Ctrl+Shift+`` 打开终端
2. 点击终端右侧的 `+` 号创建新终端
3. 在不同终端运行不同节点

**示例：**
```
终端 1: 运行 talker
终端 2: 运行 listener
终端 3: 运行 rqt_graph 查看通信
终端 4: 运行 RViz2 可视化
```

---

## 常见问题

### 1. 可视化窗口无法显示

**原因：** X11 转发未启用

**解决：**
```bash
xhost +local:docker

# 检查 DISPLAY 环境变量
echo $DISPLAY
```

### 2. Dev Container 启动失败

**原因：** 容器已存在或端口冲突

**解决：**
```bash
# 删除旧容器
docker rm -f ros2-humble

# 重新打开 Dev Container
# VSCode → Ctrl+Shift+P → Dev Containers: Reopen in Container
```

### 3. 调试时找不到模块

**原因：** Python 路径未正确设置

**解决：**
检查 `.vscode/settings.json` 中的 `python.analysis.extraPaths`：
```json
{
    "python.analysis.extraPaths": [
        "/opt/ros/humble/lib/python3.10/site-packages"
    ]
}
```

### 4. 编译后无法运行节点

**原因：** 未 source 工作空间

**解决：**
```bash
# 在容器内执行
source /opt/ros/humble/setup.bash
source /root/ros2_ws/install/setup.bash

# 或重新编译
./ros2_docker.sh build
```

### 5. VSCode 无法连接容器

**原因：** 容器未启动

**解决：**
```bash
# 检查容器状态
docker ps -a | grep ros2-humble

# 启动容器
./ros2_docker.sh start
```

---

## 性能优化

### 1. 编译优化

```bash
# 使用多线程编译
docker exec ros2-humble bash -c "source /opt/ros/humble/setup.bash && cd /root/ros2_ws && colcon build --symlink-install --parallel-workers $(nproc)"
```

### 2. 减少编译范围

```bash
# 只编译指定包
colcon build --packages-select my_pkg

# 跳过测试
colcon build --cmake-args -DBUILD_TESTING=OFF
```

### 3. VSCode 性能优化

在 `.vscode/settings.json` 添加：
```json
{
    "files.watcherExclude": {
        "**/build/**": true,
        "**/install/**": true,
        "**/log/**": true
    }
}
```

---

## 进阶技巧

### 1. 自定义调试配置

在 `.vscode/launch.json` 添加自定义调试：

```json
{
    "name": "Debug Custom Node",
    "type": "debugpy",
    "request": "launch",
    "program": "${workspaceFolder}/ros2_ws/src/my_pkg/my_pkg/my_node.py",
    "args": ["--param", "value"],
    "console": "integratedTerminal",
    "env": {
        "PYTHONPATH": "/opt/ros/humble/lib/python3.10/site-packages",
        "ROS_DISTRO": "humble"
    }
}
```

### 2. 任务依赖

在 `.vscode/tasks.json` 配置任务依赖：

```json
{
    "label": "build-and-run",
    "dependsOn": ["build-ros2", "run-talker"],
    "dependsOrder": "sequence"
}
```

### 3. 快捷键绑定

在 VSCode 中自定义快捷键：

1. 按 `Ctrl+K Ctrl+S` 打开键盘快捷方式
2. 搜索任务名称
3. 设置快捷键

**推荐快捷键：**
| 任务 | 推荐快捷键 |
|------|-----------|
| build-ros2 | `Ctrl+Shift+B` |
| run-rviz2 | `Ctrl+Alt+R` |
| run-rqt | `Ctrl+Alt+Q` |

### 4. 代码片段

创建 ROS2 代码片段，提高开发效率：

在 VSCode 中：`File → Preferences → User Snippets → python.json`

```json
{
    "ROS2 Node": {
        "prefix": "ros2-node",
        "body": [
            "import rclpy",
            "from rclpy.node import Node",
            "",
            "class ${1:NodeName}(Node):",
            "    def __init__(self):",
            "        super().__init__('${2:node_name}')",
            "        self.get_logger().info('${3:Node started}')",
            "",
            "",
            "def main(args=None):",
            "    rclpy.init(args=args)",
            "    node = ${1:NodeName}()",
            "    rclpy.spin(node)",
            "    node.destroy_node()",
            "    rclpy.shutdown()",
            "",
            "",
            "if __name__ == '__main__':",
            "    main()"
        ]
    }
}
```

---

## 总结

| 开发方式 | 适用场景 | 复杂度 | 推荐度 |
|---------|---------|--------|--------|
| Dev Container | 完整开发、团队协作 | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| 本地 VSCode + Docker | 快速开发、灵活控制 | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| 可视化工具 | 调试、监控、仿真 | ⭐ | ⭐⭐⭐⭐⭐ |

**推荐组合：** Dev Container + RViz2 + rqt + Gazebo

---

## 参考资源

- [ROS 2 Humble 文档](https://docs.ros.org/en/humble/)
- [VSCode Dev Container 文档](https://code.visualstudio.com/docs/devcontainers/containers)
- [RViz2 用户指南](https://wiki.ros.org/rviz/UserGuide)
- [Gazebo 教程](https://gazebosim.org/tutorials)
