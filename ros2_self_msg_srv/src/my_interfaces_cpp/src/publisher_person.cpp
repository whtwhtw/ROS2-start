/**
 * 发布自定义消息示例 - C++版本
 */
#include "rclcpp/rclcpp.hpp"
#include "my_interfaces/msg/person.hpp"

using std::placeholders::_1;

class PublisherPerson : public rclcpp::Node
{
public:
    PublisherPerson() : Node("publisher_person"), count_(0)
    {
        // 创建发布者，发布自定义消息Person
        publisher_ = this->create_publisher<my_interfaces::msg::Person>("person_info", 10);
        
        // 创建定时器，每1秒发布一次
        timer_ = this->create_wall_timer(
            std::chrono::seconds(1),
            std::bind(&PublisherPerson::timer_callback, this));
        
        RCLCPP_INFO(this->get_logger(), "发布者已启动，发布人员信息...");
    }

private:
    void timer_callback()
    {
        auto msg = my_interfaces::msg::Person();
        msg.name = "李四_" + std::to_string(count_);
        msg.age = 30 + (count_ % 10);
        msg.height = 1.80 + (count_ % 5) * 0.01;
        
        publisher_->publish(msg);
        RCLCPP_INFO(this->get_logger(), 
            "发布: 姓名=%s, 年龄=%d, 身高=%.2fm",
            msg.name.c_str(), msg.age, msg.height);
        count_++;
    }

    rclcpp::TimerBase::SharedPtr timer_;
    rclcpp::Publisher<my_interfaces::msg::Person>::SharedPtr publisher_;
    size_t count_;
};

int main(int argc, char * argv[])
{
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<PublisherPerson>());
    rclcpp::shutdown();
    return 0;
}
