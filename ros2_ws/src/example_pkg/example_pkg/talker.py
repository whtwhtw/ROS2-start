import rclpy
from rclpy.node import Node
from std_msgs.msg import String


class TalkerNode(Node):
    """简单的发布者节点示例"""

    def __init__(self):
        super().__init__('talker')
        self.publisher_ = self.create_publisher(String, 'chatter', 10)
        self.timer = self.create_timer(0.5, self.timer_callback)
        self.count = 0
        self.get_logger().info('Talker节点已启动!')

    def timer_callback(self):
        msg = String()
        msg.data = f'Hello ROS2 Humble! Count: {self.count}'
        self.publisher_.publish(msg)
        self.get_logger().info(f'发布: "{msg.data}"')
        self.count += 1


def main(args=None):
    rclpy.init(args=args)
    node = TalkerNode()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()
