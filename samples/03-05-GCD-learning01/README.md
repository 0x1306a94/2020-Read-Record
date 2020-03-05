title: "GCD dispatch_barrier_async 读写场景使用，以及 GCD group 实践"
date: 2020-03-05
tags: [GCD]
categories: [GCD]
keywords: GCD
description: GCD 基础知识学习。

<!--此处开始正文-->

## What is it?

GCD dispatch_barrier_async 读写场景使用，以及 GCD group 实践Demo。

## How to use?

```objective-c
// 用 dispatch_barrier_async 实现并发读，串行写操作
@interface UserCenter ()
{
    dispatch_queue_t read_write_queue;
    NSMutableDictionary *userInfo;
}
@end

@implementation UserCenter

- (instancetype)init {
    self = [super init];
    if (self) {
        read_write_queue = dispatch_queue_create("read_write_queue", DISPATCH_QUEUE_CONCURRENT);
        userInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    __block id obj;
    dispatch_async(read_write_queue, ^{
        obj = self->userInfo[key];
    });
    return obj;
}

- (void)setObject:(id)obj forKey:(NSString *)key {
    dispatch_barrier_async(read_write_queue, ^{
        self->userInfo[key] = obj;
    });
}
@end
```

## Why like this?

## Summary

## Reference
