cmake_minimum_required(VERSION 3.8)
project(example_pkg_cp)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)

# Talker节点 (发布者)
add_executable(talker src/talker.cpp)
ament_target_dependencies(talker rclcpp std_msgs)

# Listener节点 (订阅者)
add_executable(listener src/listener.cpp)
ament_target_dependencies(listener rclcpp std_msgs)

# 安装目标
install(TARGETS
  talker
  listener
  DESTINATION lib/${PROJECT_NAME}
)

# 安装目录
install(DIRECTORY include/
  DESTINATION include
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
