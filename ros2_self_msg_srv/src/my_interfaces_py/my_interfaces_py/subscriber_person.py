#!/usr/bin/env python3
"""订阅自定义消息示例 - Python版本"""
import rclpy
from rclpy.node import Node
from my_interfaces.msg import Person


class SubscriberPerson(Node):
    """订阅人员信息节点"""

    def __init__(self):
        super().__init__('subscriber_person')
        # 创建订阅者，订阅自定义消息Person
        self.subscription = self.create_subscription(
            Person,
            'person_info',
            self.listener_callback,
            10
        )
        self.subscription  # 防止未使用警告
        
        self.get_logger().info('订阅者已启动，等待消息...')

    def listener_callback(self, msg):
        """消息回调：处理接收到的消息"""
        self.get_logger().info(
            f'收到: 姓名={msg.name}, 年龄={msg.age}, 身高={msg.height:.2f}m'
        )


def main(args=None):
    rclpy.init(args=args)
    subscriber = SubscriberPerson()
    try:
        rclpy.spin(subscriber)
    except KeyboardInterrupt:
        pass
    finally:
        subscriber.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()
