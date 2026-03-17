#!/usr/bin/env python3
"""ROS2 服务端示例 - Python版本"""
import rclpy
from rclpy.node import Node
from example_interfaces.srv import AddTwoInts


class ServiceServer(Node):
    """加法服务端节点"""

    def __init__(self):
        super().__init__('service_server')
        # 创建服务，指定服务类型、服务名和回调函数
        self.srv = self.create_service(
            AddTwoInts,
            'add_two_ints',
            self.add_two_ints_callback
        )
        self.get_logger().info('服务端已启动，等待请求...')

    def add_two_ints_callback(self, request, response):
        """服务回调函数：计算两个整数的和"""
        response.sum = request.a + request.b
        self.get_logger().info(f'收到请求: a={request.a}, b={request.b}')
        self.get_logger().info(f'返回结果: sum={response.sum}')
        return response


def main(args=None):
    rclpy.init(args=args)
    server = ServiceServer()
    try:
        rclpy.spin(server)
    except KeyboardInterrupt:
        pass
    finally:
        server.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()
