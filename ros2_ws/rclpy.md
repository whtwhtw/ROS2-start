# rclpy 库功能详解

`rclpy` 是 ROS2 的 Python 客户端库，提供了完整的机器人软件开发功能。以下是主要模块分类：

---

## 1️⃣ 核心模块 (`rclpy`)

| 功能 | 代码示例 | 说明 |
|------|----------|------|
| 初始化/关闭 | `rclpy.init()` / `rclpy.shutdown()` | 管理ROS2运行时环境 |
| 事件循环 | `rclpy.spin(node)` / `rclpy.spin_once()` | 处理节点回调 |
| 执行器 | `MultiThreadedExecutor` | 多线程并发处理回调 |

```python
from rclpy.executors import MultiThreadedExecutor

executor = MultiThreadedExecutor(num_threads=4)
executor.add_node(node1)
executor.add_node(node2)
executor.spin()
```

---

## 2️⃣ 节点模块 (`rclpy.node`)

| 功能 | 代码示例 | 说明 |
|------|----------|------|
| 创建节点 | `Node('node_name')` | ROS2通信的基本单元 |
| 参数管理 | `declare_parameter()` | 动态配置参数 |
| 日志输出 | `get_logger().info()` | 结构化日志 |

```python
from rclpy.node import Node

class MyNode(Node):
    def __init__(self):
        super().__init__('my_node')
        self.declare_parameter('speed', 1.0)
        speed = self.get_parameter('speed').value
        self.get_logger().info(f'速度参数: {speed}')
```

---

## 3️⃣ 通信模块

### 📤 发布-订阅 (Topic)

```python
# 发布者
self.pub = self.create_publisher(String, 'topic', 10)
self.pub.publish(msg)

# 订阅者
self.sub = self.create_subscription(String, 'topic', callback, 10)
```

### 📥 服务 (Service)

```python
# 服务端
self.srv = self.create_service(AddTwoInts, 'add_two_ints', self.callback)

# 客户端
self.cli = self.create_client(AddTwoInts, 'add_two_ints')
future = self.cli.call_async(request)
```

### 📋 动作 (Action)

```python
# 动作客户端
from rclpy.action import ActionClient

self._action_client = ActionClient(self, Fibonacci, 'fibonacci')
goal_future = self._action_client.send_goal_async(goal)
```

---

## 4️⃣ 时间模块 (`rclpy.time`, `rclpy.timer`)

| 功能 | 代码示例 | 说明 |
|------|----------|------|
| 定时器 | `create_timer(0.5, callback)` | 周期性执行 |
| 时间戳 | `Time()` / `Clock()` | ROS时间管理 |
| Rate控制 | `create_rate(10)` | 控制循环频率 |

```python
from rclpy.time import Time
from rclpy.clock import Clock

# 定时器
self.timer = self.create_timer(1.0, self.timer_callback)

# 获取当前时间
clock = Clock()
now = clock.now()
self.get_logger().info(f'当前时间: {now.nanoseconds} ns')
```

---

## 5️⃣ 参数模块 (`rclpy.parameter`)

```python
from rclpy.parameter import Parameter

# 声明参数
self.declare_parameter('int_param', 42)
self.declare_parameter('str_param', 'hello')

# 获取参数
value = self.get_parameter('int_param').value

# 动态参数回调
from rclpy.callback_groups import MutuallyExclusiveCallbackGroup

def on_parameter_change(self, params):
    for param in params:
        if param.name == 'int_param':
            self.get_logger().info(f'参数变更: {param.value}')
    return SetParametersResult(successful=True)

self.add_on_set_parameters_callback(self.on_parameter_change)
```

---

## 6️⃣ 生命周期模块 (`rclpy.lifecycle`)

```python
from rclpy.lifecycle import LifecycleNode, LifecycleState, TransitionCallbackReturn

class MyLifecycleNode(LifecycleNode):
    def __init__(self, node_name):
        super().__init__(node_name)
    
    def on_configure(self, state: LifecycleState) -> TransitionCallbackReturn:
        self.get_logger().info('配置中...')
        return TransitionCallbackReturn.SUCCESS
    
    def on_activate(self, state: LifecycleState) -> TransitionCallbackReturn:
        self.get_logger().info('激活中...')
        return TransitionCallbackReturn.SUCCESS
```

生命周期状态转换图：

```
[Unconfigured] ──configure──▶ [Inactive] ──activate──▶ [Active]
       ▲                           │                       │
       │                       cleanup                 deactivate
       │                           │                       │
       └───────────────────────────┴───────────────────────┘
```

---

## 7️⃣ QoS 模块 (`rclpy.qos`)

服务质量策略，用于控制消息传递行为：

```python
from rclpy.qos import QoSProfile, ReliabilityPolicy, DurabilityPolicy

qos_profile = QoSProfile(
    depth=10,
    reliability=ReliabilityPolicy.RELIABLE,    # 可靠传输
    durability=DurabilityPolicy.TRANSIENT_LOCAL  # 持久化
)

self.sub = self.create_subscription(String, 'topic', callback, qos_profile)
```

### QoS 策略选项

| 策略 | 选项 | 说明 |
|------|------|------|
| Reliability | `RELIABLE` / `BEST_EFFORT` | 可靠性保证 |
| Durability | `TRANSIENT_LOCAL` / `VOLATILE` | 消息持久性 |
| Depth | 数字 | 队列深度 |
| History | `KEEP_LAST` / `KEEP_ALL` | 历史记录策略 |

---

## 8️⃣ 回调组模块 (`rclpy.callback_groups`)

```python
from rclpy.callback_groups import MutuallyExclusiveCallbackGroup, ReentrantCallbackGroup

# 互斥组：回调串行执行
self.cb_group1 = MutuallyExclusiveCallbackGroup()

# 可重入组：回调并行执行
self.cb_group2 = ReentrantCallbackGroup()

self.timer1 = self.create_timer(1.0, callback1, callback_group=self.cb_group1)
self.timer2 = self.create_timer(1.0, callback2, callback_group=self.cb_group2)
```

---

## 9️⃣ 任务模块 (`rclpy.task`)

```python
from rclpy.task import Future

# 异步任务
future = self.cli.call_async(request)
future.add_done_callback(self.response_callback)

def response_callback(self, future):
    result = future.result()
```

---

## 📊 模块功能总览

```
rclpy
├── 核心 (rclpy)         ├── init, shutdown, spin
│   └── executors        ├── SingleThreadedExecutor
│                        └── MultiThreadedExecutor
├── 节点 (node)          ├── create_publisher/subscription/service
│   ├── create_timer
│   └── declare_parameter
├── 通信
│   ├── Topic (pub/sub)
│   ├── Service (request/response)
│   └── Action (goal/feedback/result)
├── 时间 (time/timer)    ─── Timer, Clock, Time
├── 参数 (parameter)     ─── 动态参数管理
├── 生命周期 (lifecycle) ─── 状态机管理
├── QoS (qos)            ─────────── 服务质量控制
└── 回调组 (callback_groups) ───── 并发控制
```

---

## 💡 实际应用建议

| 场景 | 推荐配置 |
|------|----------|
| 简单节点 | `rclpy.spin(node)` 单线程足够 |
| 多节点/多任务 | `MultiThreadedExecutor` + 回调组 |
| 实时性要求高 | QoS `RELIABLE` + `TRANSIENT_LOCAL` |
| 需要状态管理 | 使用 `LifecycleNode` |

---

## 🔗 常用导入汇总

```python
# 核心
import rclpy
from rclpy.node import Node
from rclpy.executors import MultiThreadedExecutor, SingleThreadedExecutor

# 通信
from rclpy.action import ActionClient, ActionServer
from rclpy.callback_groups import MutuallyExclusiveCallbackGroup, ReentrantCallbackGroup

# 时间
from rclpy.timer import Timer
from rclpy.time import Time
from rclpy.clock import Clock

# 参数
from rclpy.parameter import Parameter
from rcl_interfaces.msg import SetParametersResult

# QoS
from rclpy.qos import QoSProfile, ReliabilityPolicy, DurabilityPolicy, HistoryPolicy

# 生命周期
from rclpy.lifecycle import LifecycleNode, LifecycleState, TransitionCallbackReturn

# 任务
from rclpy.task import Future
```
