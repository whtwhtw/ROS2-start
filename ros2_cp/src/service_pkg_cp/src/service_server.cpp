/**
 * ROS2 服务端示例 - C++版本
 */
#include "rclcpp/rclcpp.hpp"
#include "example_interfaces/srv/add_two_ints.hpp"

#include <memory>

class ServiceServer : public rclcpp::Node
{
public:
    ServiceServer() : Node("service_server")
    {
        // 创建服务，指定服务名和回调函数
        srv_ = this->create_service<example_interfaces::srv::AddTwoInts>(
            "add_two_ints",
            std::bind(&ServiceServer::add, this, std::placeholders::_1, std::placeholders::_2));

        RCLCPP_INFO(this->get_logger(), "服务端已启动，等待请求...");
    }

private:
    // 服务回调函数：计算两个整数的和
    void add(
        const std::shared_ptr<example_interfaces::srv::AddTwoInts::Request> request,
        std::shared_ptr<example_interfaces::srv::AddTwoInts::Response> response)
    {
        response->sum = request->a + request->b;
        RCLCPP_INFO(this->get_logger(), "收到请求: a=%ld, b=%ld", request->a, request->b);
        RCLCPP_INFO(this->get_logger(), "返回结果: sum=%ld", response->sum);
    }

    rclcpp::Service<example_interfaces::srv::AddTwoInts>::SharedPtr srv_;
};

int main(int argc, char **argv)
{
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<ServiceServer>());
    rclcpp::shutdown();
    return 0;
}
