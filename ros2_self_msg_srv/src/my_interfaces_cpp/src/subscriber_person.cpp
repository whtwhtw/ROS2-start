/**
 * 订阅自定义消息示例 - C++版本
 */
#include "rclcpp/rclcpp.hpp"
#include "my_interfaces/msg/person.hpp"

class SubscriberPerson : public rclcpp::Node
{
public:
    SubscriberPerson() : Node("subscriber_person")
    {
        // 创建订阅者，订阅自定义消息Person
        subscription_ = this->create_subscription<my_interfaces::msg::Person>(
            "person_info", 10,
            std::bind(&SubscriberPerson::topic_callback, this, std::placeholders::_1));
        
        RCLCPP_INFO(this->get_logger(), "订阅者已启动，等待消息...");
    }

private:
    void topic_callback(const my_interfaces::msg::Person::SharedPtr msg)
    {
        RCLCPP_INFO(this->get_logger(), 
            "收到: 姓名=%s, 年龄=%d, 身高=%.2fm",
            msg->name.c_str(), msg->age, msg->height);
    }

    rclcpp::Subscription<my_interfaces::msg::Person>::SharedPtr subscription_;
};

int main(int argc, char * argv[])
{
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<SubscriberPerson>());
    rclcpp::shutdown();
    return 0;
}
