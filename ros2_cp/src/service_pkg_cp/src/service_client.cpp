/**
 * ROS2 客户端示例 - C++版本
 */
#include "rclcpp/rclcpp.hpp"
#include "example_interfaces/srv/add_two_ints.hpp"

#include <cstdlib>
#include <memory>

class ServiceClient : public rclcpp::Node
{
public:
    ServiceClient() : Node("service_client")
    {
        // 创建客户端
        client_ = this->create_client<example_interfaces::srv::AddTwoInts>("add_two_ints");

        // 等待服务端启动
        while (!client_->wait_for_service(std::chrono::seconds(1)))
        {
            if (!rclcpp::ok())
            {
                RCLCPP_ERROR(this->get_logger(), "等待服务时被中断");
                return;
            }
            RCLCPP_INFO(this->get_logger(), "等待服务端启动...");
        }

        RCLCPP_INFO(this->get_logger(), "服务端已连接");
    }

    // 发送请求并返回 future
    rclcpp::Client<example_interfaces::srv::AddTwoInts>::SharedFuture send_request(int64_t a, int64_t b)
    {
        // 创建请求对象
        auto request = std::make_shared<example_interfaces::srv::AddTwoInts::Request>();
        request->a = a;
        request->b = b;

        // 异步发送请求（不使用回调）
        return client_->async_send_request(request).future.share();
    }

private:
    rclcpp::Client<example_interfaces::srv::AddTwoInts>::SharedPtr client_;
};

int main(int argc, char **argv)
{
    rclcpp::init(argc, argv);

    auto client = std::make_shared<ServiceClient>();

    // 从命令行参数获取两个整数
    int64_t a = (argc >= 3) ? atoll(argv[1]) : 41;
    int64_t b = (argc >= 3) ? atoll(argv[2]) : 1;

    // 发送请求
    auto future_result = client->send_request(a, b);

    // 等待响应完成
    if (rclcpp::spin_until_future_complete(client, future_result) ==
        rclcpp::FutureReturnCode::SUCCESS)
    {
        auto response = future_result.get();
        RCLCPP_INFO(client->get_logger(), "请求: %ld + %ld", a, b);
        RCLCPP_INFO(client->get_logger(), "响应: %ld", response->sum);
    }
    else
    {
        RCLCPP_ERROR(client->get_logger(), "请求失败");
    }

    rclcpp::shutdown();
    return 0;
}
