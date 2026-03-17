#!/usr/bin/env python3
"""发布自定义消息示例 - Python版本"""
import rclpy
from rclpy.node import Node
from my_interfaces.msg import Person


class PublisherPerson(Node):
    """发布人员信息节点"""

    def __init__(self):
        super().__init__('publisher_person')
        # 创建发布者，发布自定义消息Person
        self.publisher_ = self.create_publisher(Person, 'person_info', 10)
        
        # 创建定时器，每1秒发布一次
        self.timer = self.create_timer(1.0, self.timer_callback)
        self.count = 0
        
        self.get_logger().info('发布者已启动，发布人员信息...')

    def timer_callback(self):
        """定时器回调：创建并发布消息"""
        msg = Person()
        msg.name = f'张三_{self.count}'
        msg.age = 25 + (self.count % 10)
        msg.height = 1.75 + (self.count % 5) * 0.01
        
        self.publisher_.publish(msg)
        self.get_logger().info(
            f'发布: 姓名={msg.name}, 年龄={msg.age}, 身高={msg.height:.2f}m'
        )
        self.count += 1


def main(args=None):
    rclpy.init(args=args)
    publisher = PublisherPerson()
    try:
        rclpy.spin(publisher)
    except KeyboardInterrupt:
        pass
    finally:
        publisher.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()
