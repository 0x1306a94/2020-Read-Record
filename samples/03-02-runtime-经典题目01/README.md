title: "Runtime 经典题目01"
date: 日期
tags: [runtime]
categories: [runtime]
keywords: runtime
description: 主要考察了堆栈、runtime 类对象、内存对齐方式等知识点。

<!--此处开始正文-->

## What is it?

obj 是一个指针，存储了 cls 变量在栈上的地址，而 cls 变量所在栈上的8字节地址又存储了**A 类对象的地址（是堆上地址）**，此处可以把 cls 看作是一个分配在栈上的**实例**变量。

`[((__bridge id)obj) print]` 这句代码理解的时候尽量还是把 obj 替换成 cls 所在栈上的地址吧。

## How to use?

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *name = @"pmst";
    id cls = [A class]; // 相当于在栈上分配了一块内存 其实就8个字节 isa
    void *obj = &cls; // obj 指针变量存储了 cls 变量所在的栈地址， &obj 则是 obj 变量在栈上的地址。
    // obj 指针值就是 cls 所在的栈地址，内容是8字节的 isa 指针
    // *obj 指向了 A 类对象
    [((__bridge id)obj) print];
}
```

## Why like this?

## Summary

## Reference
