cmake_minimum_required(VERSION 3.8)
project(my_interfaces_cpp)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(my_interfaces REQUIRED)

# 发布者节点
add_executable(publisher_person src/publisher_person.cpp)
ament_target_dependencies(publisher_person rclcpp my_interfaces)

# 订阅者节点
add_executable(subscriber_person src/subscriber_person.cpp)
ament_target_dependencies(subscriber_person rclcpp my_interfaces)

# 服务端节点
add_executable(service_server src/service_server.cpp)
ament_target_dependencies(service_server rclcpp my_interfaces)

# 客户端节点
add_executable(service_client src/service_client.cpp)
ament_target_dependencies(service_client rclcpp my_interfaces)

# 安装目标
install(TARGETS
  publisher_person
  subscriber_person
  service_server
  service_client
  DESTINATION lib/${PROJECT_NAME}
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
