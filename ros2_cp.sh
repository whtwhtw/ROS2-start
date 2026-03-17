#!/bin/bash
# ROS 2 Humble Docker 管理脚本 - C++版本 (ros2_cp)

COMPOSE_FILE="/media/wht/N/ROS/.devcontainer/docker-compose.yml"
SERVICE_NAME="ros2-humble-cp"
CONTAINER_NAME="ros2-humble-cp"

start_container() {
    xhost +local:docker
    if docker inspect --format '{{.State.Running}}' $CONTAINER_NAME 2>/dev/null | grep -q "true"; then
        echo "容器 $CONTAINER_NAME 已在运行"
    elif docker inspect $CONTAINER_NAME &>/dev/null; then
        echo "启动容器 $CONTAINER_NAME..."
        docker start $CONTAINER_NAME
    else
        echo "创建并启动容器 $CONTAINER_NAME..."
        docker compose -f $COMPOSE_FILE up -d $SERVICE_NAME
    fi
}

stop_container() {
    echo "停止容器 $CONTAINER_NAME..."
    docker compose -f $COMPOSE_FILE stop $SERVICE_NAME
}

remove_container() {
    echo "删除容器 $CONTAINER_NAME..."
    docker compose -f $COMPOSE_FILE down --remove-orphans
}

shell() {
    echo "进入容器 $CONTAINER_NAME 的bash..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && bash"
}

build() {
    echo "编译ROS2工作空间 (C++版本)..."
    docker exec $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && cd /root/ros2_cp && colcon build"
}

run_example() {
    echo "运行示例..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_cp/install/setup.bash && ros2 run example_pkg_cp talker"
}

run_talker() {
    echo "启动发布者节点 (C++版本)..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_cp/install/setup.bash && ros2 run example_pkg_cp talker"
}

run_listener() {
    echo "启动订阅者节点 (C++版本)..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_cp/install/setup.bash && ros2 run example_pkg_cp listener"
}

run_service_server() {
    echo "启动服务端节点 (C++版本)..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_cp/install/setup.bash && ros2 run service_pkg_cp service_server"
}

run_service_client() {
    echo "启动客户端节点 (C++版本)..."
    local args="${@:2}"
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_cp/install/setup.bash && ros2 run service_pkg_cp service_client $args"
}

run_turtlesim() {
    echo "启动 turtlesim..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && ros2 run turtlesim turtlesim_node"
}

run_teleop() {
    echo "启动 turtle_teleop_key..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && ros2 run turtlesim turtle_teleop_key"
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
    service_server)
        run_service_server "$@"
        ;;
    service_client)
        run_service_client "$@"
        ;;
    turtlesim)
        run_turtlesim
        ;;
    teleop)
        run_teleop
        ;;
    *)
        echo "用法: $0 {start|stop|rm|shell|build|run|talker|listener|service_server|service_client|turtlesim|teleop}"
        echo ""
        echo "命令说明:"
        echo "  start          - 启动容器"
        echo "  stop           - 停止容器"
        echo "  rm             - 删除容器"
        echo "  shell          - 进入容器bash"
        echo "  build          - 编译工作空间"
        echo "  run            - 运行示例节点(talker)"
        echo "  talker         - 启动发布者节点"
        echo "  listener       - 启动订阅者节点"
        echo "  service_server - 启动服务端节点"
        echo "  service_client - 启动客户端节点 (可带两个数字参数，如: ./ros2_cp.sh service_client 3 5)"
        echo "  turtlesim      - 启动小乌龟仿真"
        echo "  teleop         - 启动小乌龟键盘控制"
        exit 1
        ;;
esac
