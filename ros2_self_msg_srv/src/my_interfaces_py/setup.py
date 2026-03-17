from setuptools import setup

package_name = 'my_interfaces_py'

setup(
    name=package_name,
    version='0.0.0',
    packages=[package_name],
    data_files=[
        ('share/ament_index/resource_index_packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='root',
    maintainer_email='root@todo.todo',
    description='Python版本：使用自定义msg和srv接口示例',
    license='Apache-2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'publisher_person = my_interfaces_py.publisher_person:main',
            'subscriber_person = my_interfaces_py.subscriber_person:main',
            'service_server = my_interfaces_py.service_server:main',
            'service_client = my_interfaces_py.service_client:main',
        ],
    },
)
