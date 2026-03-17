#!/usr/bin/env python3
"""ROS2 客户端示例 - Python版本"""
import sys
import rclpy
from rclpy.node import Node
from example_interfaces.srv import AddTwoInts


class ServiceClient(Node):
    """加法客户端节点"""

    def __init__(self):
        super().__init__('service_client')
        # 创建客户端，指定服务类型和服务名
        self.client = self.create_client(AddTwoInts, 'add_two_ints')

        # 等待服务端启动
        while not self.client.wait_for_service(timeout_sec=1.0):
            self.get_logger().info('等待服务端启动...')

        self.get_logger().info('服务端已连接')

    def send_request(self, a, b):
        """发送请求"""
        # 创建请求对象
        request = AddTwoInts.Request()
        request.a = a
        request.b = b

        # 异步发送请求
        self.future = self.client.call_async(request)
        return self.future


def main(args=None):
    rclpy.init(args=args)

    client = ServiceClient()

    # 从命令行参数获取两个整数
    if len(sys.argv) == 3:
        a = int(sys.argv[1])
        b = int(sys.argv[2])
    else:
        a = 41
        b = 1

    # 发送请求
    future = client.send_request(a, b)

    # 等待响应
    rclpy.spin_until_future_complete(client, future)

    # 获取结果
    if future.result() is not None:
        client.get_logger().info(f'请求: {a} + {b}')
        client.get_logger().info(f'响应: {future.result().sum}')
    else:
        client.get_logger().error(f'请求失败: {future.exception()}')

    client.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
