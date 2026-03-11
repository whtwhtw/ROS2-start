#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/string.hpp>

class TalkerNode : public rclcpp::Node
{
public:
    TalkerNode() : Node("talker"), count_(0)
    {
        // 创建发布者，话题名为"chatter"，队列深度为10
        publisher_ = this->create_publisher<std_msgs::msg::String>("chatter", 10);
        
        // 创建定时器，每500ms回调一次
        timer_ = this->create_wall_timer(
            std::chrono::milliseconds(500),
            std::bind(&TalkerNode::timer_callback, this));
        
        RCLCPP_INFO(this->get_logger(), "Talker节点已启动!");
    }

private:
    void timer_callback()
    {
        auto message = std_msgs::msg::String();
        message.data = "Hello ROS2 Humble! Count: " + std::to_string(count_++);
        
        RCLCPP_INFO(this->get_logger(), "发布: '%s'", message.data.c_str());
        publisher_->publish(message);
    }

    rclcpp::Publisher<std_msgs::msg::String>::SharedPtr publisher_;
    rclcpp::TimerBase::SharedPtr timer_;
    size_t count_;
};

int main(int argc, char *argv[])
{
    rclcpp::init(argc, argv);
    auto node = std::make_shared<TalkerNode>();
    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}
