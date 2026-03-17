cmake_minimum_required(VERSION 3.8)
project(service_pkg_cp)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(example_interfaces REQUIRED)

# 服务端节点
add_executable(service_server src/service_server.cpp)
ament_target_dependencies(service_server rclcpp example_interfaces)

# 客户端节点
add_executable(service_client src/service_client.cpp)
ament_target_dependencies(service_client rclcpp example_interfaces)

# 安装目标
install(TARGETS
  service_server
  service_client
  DESTINATION lib/${PROJECT_NAME}
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
