/**
 * 服务端示例 - C++版本：使用自定义srv
 */
#include "rclcpp/rclcpp.hpp"
#include "my_interfaces/srv/add_three_ints.hpp"

#include <memory>

class ServiceServer : public rclcpp::Node
{
public:
    ServiceServer() : Node("service_server")
    {
        // 创建服务，使用自定义服务类型
        srv_ = this->create_service<my_interfaces::srv::AddThreeInts>(
            "add_three_ints",
            std::bind(&ServiceServer::add, this, std::placeholders::_1, std::placeholders::_2));

        RCLCPP_INFO(this->get_logger(), "服务端已启动，等待请求...");
    }

private:
    void add(
        const std::shared_ptr<my_interfaces::srv::AddThreeInts::Request> request,
        std::shared_ptr<my_interfaces::srv::AddThreeInts::Response> response)
    {
        response->sum = request->a + request->b + request->c;
        RCLCPP_INFO(this->get_logger(), 
            "收到请求: a=%ld, b=%ld, c=%ld", 
            request->a, request->b, request->c);
        RCLCPP_INFO(this->get_logger(), "返回结果: sum=%ld", response->sum);
    }

    rclcpp::Service<my_interfaces::srv::AddThreeInts>::SharedPtr srv_;
};

int main(int argc, char **argv)
{
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<ServiceServer>());
    rclcpp::shutdown();
    return 0;
}
