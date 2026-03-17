#!/bin/bash
# ROS 2 Humble Docker 管理脚本 - 自定义接口示例 (ros2_self_msg_srv)

COMPOSE_FILE="/media/wht/N/ROS/.devcontainer/docker-compose.yml"
SERVICE_NAME="ros2-humble-msg"
CONTAINER_NAME="ros2-humble-msg"

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
    echo "编译ROS2工作空间 (自定义接口示例)..."
    docker exec $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && cd /root/ros2_self_msg_srv && colcon build --symlink-install"
}

# Python版本节点
run_publisher_person_py() {
    echo "启动发布者节点 (Python版本)..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_self_msg_srv/install/setup.bash && ros2 run my_interfaces_py publisher_person"
}

run_subscriber_person_py() {
    echo "启动订阅者节点 (Python版本)..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_self_msg_srv/install/setup.bash && ros2 run my_interfaces_py subscriber_person"
}

run_service_server_py() {
    echo "启动服务端节点 (Python版本)..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_self_msg_srv/install/setup.bash && ros2 run my_interfaces_py service_server"
}

run_service_client_py() {
    echo "启动客户端节点 (Python版本)..."
    local args="${@:2}"
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_self_msg_srv/install/setup.bash && ros2 run my_interfaces_py service_client $args"
}

# C++版本节点
run_publisher_person_cpp() {
    echo "启动发布者节点 (C++版本)..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_self_msg_srv/install/setup.bash && ros2 run my_interfaces_cpp publisher_person"
}

run_subscriber_person_cpp() {
    echo "启动订阅者节点 (C++版本)..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_self_msg_srv/install/setup.bash && ros2 run my_interfaces_cpp subscriber_person"
}

run_service_server_cpp() {
    echo "启动服务端节点 (C++版本)..."
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_self_msg_srv/install/setup.bash && ros2 run my_interfaces_cpp service_server"
}

run_service_client_cpp() {
    echo "启动客户端节点 (C++版本)..."
    local args="${@:2}"
    docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/humble/setup.bash && source /root/ros2_self_msg_srv/install/setup.bash && ros2 run my_interfaces_cpp service_client $args"
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
    # Python版本
    pub_py)
        run_publisher_person_py
        ;;
    sub_py)
        run_subscriber_person_py
        ;;
    server_py)
        run_service_server_py
        ;;
    client_py)
        run_service_client_py "$@"
        ;;
    # C++版本
    pub_cpp)
        run_publisher_person_cpp
        ;;
    sub_cpp)
        run_subscriber_person_cpp
        ;;
    server_cpp)
        run_service_server_cpp
        ;;
    client_cpp)
        run_service_client_cpp "$@"
        ;;
    turtlesim)
        run_turtlesim
        ;;
    teleop)
        run_teleop
        ;;
    *)
        echo "用法: $0 {start|stop|rm|shell|build|pub_py|sub_py|server_py|client_py|pub_cpp|sub_cpp|server_cpp|client_cpp|turtlesim|teleop}"
        echo ""
        echo "命令说明:"
        echo "  start      - 启动容器"
        echo "  stop       - 停止容器"
        echo "  rm         - 删除容器"
        echo "  shell      - 进入容器bash"
        echo "  build      - 编译工作空间"
        echo ""
        echo "  Python版本:"
        echo "  pub_py     - 启动发布者节点 (发布Person消息)"
        echo "  sub_py     - 启动订阅者节点 (订阅Person消息)"
        echo "  server_py  - 启动服务端节点 (AddThreeInts)"
        echo "  client_py  - 启动客户端节点 (可带三个数字参数)"
        echo ""
        echo "  C++版本:"
        echo "  pub_cpp    - 启动发布者节点 (发布Person消息)"
        echo "  sub_cpp    - 启动订阅者节点 (订阅Person消息)"
        echo "  server_cpp - 启动服务端节点 (AddThreeInts)"
        echo "  client_cpp - 启动客户端节点 (可带三个数字参数)"
        echo ""
        echo "  turtlesim  - 启动小乌龟仿真"
        echo "  teleop     - 启动小乌龟键盘控制"
        echo ""
        echo "示例:"
        echo "  $0 client_py 1 2 3   # Python客户端: 1+2+3"
        echo "  $0 client_cpp 4 5 6  # C++客户端: 4+5+6"
        exit 1
        ;;
esac
