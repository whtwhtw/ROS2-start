// NOLINT: This file starts with a BOM since it contain non-ASCII characters
// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from my_interfaces:msg/Person.idl
// generated code does not contain a copyright notice

#ifndef MY_INTERFACES__MSG__DETAIL__PERSON__STRUCT_H_
#define MY_INTERFACES__MSG__DETAIL__PERSON__STRUCT_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>


// Constants defined in the message

// Include directives for member types
// Member 'name'
#include "rosidl_runtime_c/string.h"

/// Struct defined in msg/Person in the package my_interfaces.
/**
  * 自定义消息：人员信息
 */
typedef struct my_interfaces__msg__Person
{
  /// 姓名
  rosidl_runtime_c__String name;
  /// 年龄
  int32_t age;
  /// 身高(m)
  double height;
} my_interfaces__msg__Person;

// Struct for a sequence of my_interfaces__msg__Person.
typedef struct my_interfaces__msg__Person__Sequence
{
  my_interfaces__msg__Person * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} my_interfaces__msg__Person__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // MY_INTERFACES__MSG__DETAIL__PERSON__STRUCT_H_
