#!/bin/bash
# ROS 2 Humble Docker 管理脚本 - Python版本 (ros2_ws)

CONTAINER_NAME="ros2-humble-ws"
IMAGE_NAME="osrf/ros:humble-desktop-full"
WORKSPACE="/media/wht/N/ROS/ros2_ws"

start_container() {
    if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
        if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
            echo "容器 $CONTAINER_NAME 已在运行"
        else
            echo "启动容器 $CONTAINER_NAME..."
            docker start $CONTAINER_NAME
            xhost +local:docker
        fi
    else
        echo "创建并启动容器 $CONTAINER_NAME..."
        xhost +local:docker
        docker run -d \
            --name $CONTAINER_NAME \
            --privileged \
            -e DISPLAY=$DISPLAY \
            -e QT_X11_NO_MITSHM=1 \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v $WORKSPACE:/root/ros2_ws \
            -v ~/.ssh:/root/.ssh:ro \
            -w /root/ros2_ws \
            $IMAGE_NAME \
            tail -f /dev/null
    fi
}

stop_container() {
    echo "停止容器 $CONTAINER_NAME..."
    docker stop $CONTAINER_NAME 2>/dev/null
}

remove_container() {
    echo "删除容器 $CONTAINER_NAME..."
    docker rm -f $CONTAINER_NAME 2>/dev/null
}

shell() {
    echo "进入容器 $CONTAINER_NAME 的bash..."
    docker exec -it $CONTAINER_NAME bash
}

build() {
    echo "编译ROS2工作空间 (Python版本)..."
    docker exec $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && cd /root/ros2_ws && colcon build --symlink-install"
}

run_example() {
    echo "运行示例..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/setup.bash && ros2 run example_pkg talker"
}

run_talker() {
    echo "启动发布者节点 (Python版本)..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/setup.bash && ros2 run example_pkg talker"
}

run_listener() {
    echo "启动订阅者节点 (Python版本)..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/setup.bash && ros2 run example_pkg listener"
}

case "$1" in
    start)
        start_container
        ;;
    stop)
        stop_container
        ;;
    rm)
        remove_container
        ;;
    shell|sh)
        shell
        ;;
    build)
        build
        ;;
    run)
        run_example
        ;;
    talker)
        run_talker
        ;;
    listener)
        run_listener
        ;;
    *)
        echo "用法: $0 {start|stop|rm|shell|build|run|talker|listener}"
        echo ""
        echo "命令说明:"
        echo "  start    - 启动容器"
        echo "  stop     - 停止容器"
        echo "  rm       - 删除容器"
        echo "  shell    - 进入容器bash"
        echo "  build    - 编译工作空间"
        echo "  run      - 运行示例节点(talker)"
        echo "  talker   - 启动发布者节点"
        echo "  listener - 启动订阅者节点"
        exit 1
        ;;
esac
