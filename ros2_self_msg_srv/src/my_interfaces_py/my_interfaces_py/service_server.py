#!/usr/bin/env python3
"""服务端示例 - Python版本：使用自定义srv"""
import rclpy
from rclpy.node import Node
from my_interfaces.srv import AddThreeInts


class ServiceServer(Node):
    """三个整数相加服务端"""

    def __init__(self):
        super().__init__('service_server')
        # 创建服务，使用自定义服务类型
        self.srv = self.create_service(
            AddThreeInts,
            'add_three_ints',
            self.add_callback
        )
        self.get_logger().info('服务端已启动，等待请求...')

    def add_callback(self, request, response):
        """服务回调：计算三个整数的和"""
        response.sum = request.a + request.b + request.c
        self.get_logger().info(
            f'收到请求: a={request.a}, b={request.b}, c={request.c}'
        )
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
