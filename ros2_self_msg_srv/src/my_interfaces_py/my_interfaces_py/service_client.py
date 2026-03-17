#!/usr/bin/env python3
"""客户端示例 - Python版本：使用自定义srv"""
import sys
import rclpy
from rclpy.node import Node
from my_interfaces.srv import AddThreeInts


class ServiceClient(Node):
    """三个整数相加客户端"""

    def __init__(self):
        super().__init__('service_client')
        # 创建客户端，使用自定义服务类型
        self.client = self.create_client(AddThreeInts, 'add_three_ints')

        # 等待服务端启动
        while not self.client.wait_for_service(timeout_sec=1.0):
            self.get_logger().info('等待服务端启动...')

        self.get_logger().info('服务端已连接')

    def send_request(self, a, b, c):
        """发送请求"""
        request = AddThreeInts.Request()
        request.a = a
        request.b = b
        request.c = c
        self.future = self.client.call_async(request)
        return self.future


def main(args=None):
    rclpy.init(args=args)

    client = ServiceClient()

    # 从命令行参数获取三个整数
    if len(sys.argv) == 4:
        a = int(sys.argv[1])
        b = int(sys.argv[2])
        c = int(sys.argv[3])
    else:
        a, b, c = 1, 2, 3

    # 发送请求
    future = client.send_request(a, b, c)

    # 等待响应
    rclpy.spin_until_future_complete(client, future)

    # 获取结果
    if future.result() is not None:
        client.get_logger().info(f'请求: {a} + {b} + {c}')
        client.get_logger().info(f'响应: {future.result().sum}')
    else:
        client.get_logger().error(f'请求失败: {future.exception()}')

    client.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
