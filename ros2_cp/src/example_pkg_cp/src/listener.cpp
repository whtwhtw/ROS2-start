#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/string.hpp>

class ListenerNode : public rclcpp::Node
{
public:
    ListenerNode() : Node("listener")
    {
        // 创建订阅者，订阅"chatter"话题
        subscription_ = this->create_subscription<std_msgs::msg::String>(
            "chatter",
            10,
            std::bind(&ListenerNode::listener_callback, this, std::placeholders::_1));
        
        RCLCPP_INFO(this->get_logger(), "Listener节点已启动!");
    }

private:
    void listener_callback(const std_msgs::msg::String::SharedPtr msg)
    {
        RCLCPP_INFO(this->get_logger(), "收到: '%s'", msg->data.c_str());
    }

    rclcpp::Subscription<std_msgs::msg::String>::SharedPtr subscription_;
};

int main(int argc, char *argv[])
{
    rclcpp::init(argc, argv);
    auto node = std::make_shared<ListenerNode>();
    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}
