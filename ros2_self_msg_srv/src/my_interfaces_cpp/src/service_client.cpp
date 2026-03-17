/**
 * 客户端示例 - C++版本：使用自定义srv
 */
#include "rclcpp/rclcpp.hpp"
#include "my_interfaces/srv/add_three_ints.hpp"

#include <cstdlib>
#include <memory>

class ServiceClient : public rclcpp::Node
{
public:
    ServiceClient() : Node("service_client")
    {
        // 创建客户端
        client_ = this->create_client<my_interfaces::srv::AddThreeInts>("add_three_ints");

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

    rclcpp::Client<my_interfaces::srv::AddThreeInts>::SharedFuture send_request(int64_t a, int64_t b, int64_t c)
    {
        auto request = std::make_shared<my_interfaces::srv::AddThreeInts::Request>();
        request->a = a;
        request->b = b;
        request->c = c;

        return client_->async_send_request(request).future.share();
    }

private:
    rclcpp::Client<my_interfaces::srv::AddThreeInts>::SharedPtr client_;
};

int main(int argc, char **argv)
{
    rclcpp::init(argc, argv);

    auto client = std::make_shared<ServiceClient>();

    // 从命令行参数获取三个整数
    int64_t a = (argc >= 4) ? atoll(argv[1]) : 1;
    int64_t b = (argc >= 4) ? atoll(argv[2]) : 2;
    int64_t c = (argc >= 4) ? atoll(argv[3]) : 3;

    // 发送请求
    auto future_result = client->send_request(a, b, c);

    // 等待响应完成
    if (rclcpp::spin_until_future_complete(client, future_result) ==
        rclcpp::FutureReturnCode::SUCCESS)
    {
        auto response = future_result.get();
        RCLCPP_INFO(client->get_logger(), "请求: %ld + %ld + %ld", a, b, c);
        RCLCPP_INFO(client->get_logger(), "响应: %ld", response->sum);
    }
    else
    {
        RCLCPP_ERROR(client->get_logger(), "请求失败");
    }

    rclcpp::shutdown();
    return 0;
}
