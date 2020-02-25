title: "KVO 入门"
date: 2020-02-25
tags: [KVO]
categories: [iOS底层原理]
keywords: KVO
description: 探究 KVO 如何使用以及底层实现。

<!--此处开始正文-->

## What is it?

关于 KVO 如何使用以及实现原理就不展开了，今日主要是温顾 Runtime 部分知识点，写了个简单的 Util 来打印 类中的 property 、ivars、method 以及 protocol，代码见下，希望后面将其封装一个 runtime 专门的调试工具或者说 utils 来进行日常使用。

> 本文并未探究 KVO 底层实现细节，不过希望还是能动手实现一个自己的 KVO 玩。不过这个并非是当务之急，个人认为日常开发中如何借助 KVO 来解决问题，以及如何避免 KVO 的坑，如何最大化发挥 KVO 的优势才是重点。因为本文只是个展开，后续还会有个应用篇。

## How to use?

```objective-c
@interface RuntimeUtil : NSObject

@end

@implementation RuntimeUtil

- (void)printMethods:(Class)cls {
    NSLog(@"==== OUTPUT:%@ Method ====",NSStringFromClass(cls));
    unsigned int count ;
    Method *methods = class_copyMethodList(cls, &count);
    
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        NSString *name = NSStringFromSelector(method_getName(method));
        NSLog(@"method name:%@\n",name);
    }
    free(methods);
}

- (void)printProperties:(Class)cls {
    NSLog(@"==== OUTPUT:%@ properties ====",NSStringFromClass(cls));
    
    unsigned int count ;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t prop = properties[i];
        const char *name = property_getName(prop);
        const char *attributes = property_getAttributes(prop);
        // TODO: attributes 转成 human read
        NSLog(@"property name：%s 属性：%s\n",name,attributes);
    }
    free(properties);
}

- (void)printIvars:(Class)cls {
    NSLog(@"==== OUTPUT:%@ Ivars ====",NSStringFromClass(cls));
    
    unsigned int count ;
    Ivar *ivars = class_copyIvarList(cls, &count);
    
    for (int i = 0; i < count; i++) {
        Ivar var = ivars[i];
        const char *name = ivar_getName(var);
        const char *encode = ivar_getTypeEncoding(var);
        // 类似 int32_t
        ptrdiff_t offset = ivar_getOffset(var);
        // TODO: attributes 转成 human read
        NSLog(@"ivar name：%s encode：%s 偏移量：%lu\n",name,encode,offset);
    }
    free(ivars);
}

- (void)printProtocols:(Class)cls {
    NSLog(@"==== OUTPUT:%@ Protocols ====",NSStringFromClass(cls));
    
    unsigned int count ;
    Protocol * __unsafe_unretained _Nonnull *protocols = class_copyProtocolList(cls, &count);
    
    for (int i = 0; i < count; i++) {
        Protocol * __unsafe_unretained _Nonnull protocol = protocols[i];
        const char *name = protocol_getName(protocol);
        NSLog(@"Protocol:%s 方法声明如下：",name);
        
        unsigned int methodcnt;
        struct objc_method_description * methodlist = protocol_copyMethodDescriptionList(protocol, YES, YES, &methodcnt);
        for (int j =0; j < methodcnt; j++) {
            struct objc_method_description desc = methodlist[j];
            NSLog(@"SEL %@ 类型：%s\n",NSStringFromSelector(desc.name), desc.types);
        }
        free(methodlist);
        
        NSLog(@"Protocol:%s 属性声明如下：",name);
        unsigned int protcnt;
        objc_property_t *properties = protocol_copyPropertyList(protocol, &protcnt);
        
        for (int i = 0; i < count; i++) {
            objc_property_t prop = properties[i];
            const char *name = property_getName(prop);
            const char *attributes = property_getAttributes(prop);
            // TODO: attributes 转成 human read
            NSLog(@"property name：%s 属性：%s\n",name,attributes);
        }
        free(properties);
        
    }
    free(protocols);
}

- (void)logClassInfo:(Class)cls {
    NSLog(@"LOG:(%@) INFO",NSStringFromClass(cls));
    [self printProperties:cls];
    [self printIvars:cls];
    [self printMethods:cls];
    [self printProtocols:cls];
    NSLog(@"=========================\n");
}


@end
```

Console output:

```shell
2020-02-25 23:55:06.272639+0800 02-25-KVO[18650:5338623] LOG:(Person) INFO
2020-02-25 23:55:06.272814+0800 02-25-KVO[18650:5338623] ==== OUTPUT:Person properties ====
2020-02-25 23:55:06.272978+0800 02-25-KVO[18650:5338623] property name：name 属性：T@"NSString",&,N,V_name

2020-02-25 23:55:06.273123+0800 02-25-KVO[18650:5338623] property name：age 属性：Tq,N,V_age

2020-02-25 23:55:06.273276+0800 02-25-KVO[18650:5338623] ==== OUTPUT:Person Ivars ====
2020-02-25 23:55:06.273407+0800 02-25-KVO[18650:5338623] ivar name：_name encode：@"NSString" 偏移量：8

2020-02-25 23:55:06.273541+0800 02-25-KVO[18650:5338623] ivar name：_age encode：q 偏移量：16

2020-02-25 23:55:06.273662+0800 02-25-KVO[18650:5338623] ==== OUTPUT:Person Method ====
2020-02-25 23:55:06.273805+0800 02-25-KVO[18650:5338623] method name:initWithName:age:
2020-02-25 23:55:06.273919+0800 02-25-KVO[18650:5338623] method name:personMethod
2020-02-25 23:55:06.274033+0800 02-25-KVO[18650:5338623] method name:.cxx_destruct
2020-02-25 23:55:06.274134+0800 02-25-KVO[18650:5338623] method name:name
2020-02-25 23:55:06.274312+0800 02-25-KVO[18650:5338623] method name:setName:
2020-02-25 23:55:06.310610+0800 02-25-KVO[18650:5338623] method name:age
2020-02-25 23:55:06.310820+0800 02-25-KVO[18650:5338623] method name:setAge:
2020-02-25 23:55:06.310953+0800 02-25-KVO[18650:5338623] ==== OUTPUT:Person Protocols ====
2020-02-25 23:55:06.311112+0800 02-25-KVO[18650:5338623] =========================
2020-02-25 23:55:06.311486+0800 02-25-KVO[18650:5338623] LOG:(NSKVONotifying_Person) INFO
2020-02-25 23:55:06.311614+0800 02-25-KVO[18650:5338623] ==== OUTPUT:NSKVONotifying_Person properties ====
2020-02-25 23:55:06.311749+0800 02-25-KVO[18650:5338623] ==== OUTPUT:NSKVONotifying_Person Ivars ====
2020-02-25 23:55:06.311870+0800 02-25-KVO[18650:5338623] ==== OUTPUT:NSKVONotifying_Person Method ====
2020-02-25 23:55:06.311991+0800 02-25-KVO[18650:5338623] method name:setAge:
2020-02-25 23:55:06.312106+0800 02-25-KVO[18650:5338623] method name:class
2020-02-25 23:55:06.312222+0800 02-25-KVO[18650:5338623] method name:dealloc
2020-02-25 23:55:06.312341+0800 02-25-KVO[18650:5338623] method name:_isKVOA
2020-02-25 23:55:06.315955+0800 02-25-KVO[18650:5338623] ==== OUTPUT:NSKVONotifying_Person Protocols ====
2020-02-25 23:55:06.316086+0800 02-25-KVO[18650:5338623] =========================
2020-02-25 23:55:06.316217+0800 02-25-KVO[18650:5338623] LOG:(Teacher) INFO
2020-02-25 23:55:06.316336+0800 02-25-KVO[18650:5338623] ==== OUTPUT:Teacher properties ====
2020-02-25 23:55:06.316469+0800 02-25-KVO[18650:5338623] property name：work 属性：T@"NSString",&,N,V_work

2020-02-25 23:55:06.316579+0800 02-25-KVO[18650:5338623] property name：numberOfStudent 属性：Tq,N,V_numberOfStudent

2020-02-25 23:55:06.316696+0800 02-25-KVO[18650:5338623] ==== OUTPUT:Teacher Ivars ====
2020-02-25 23:55:06.316811+0800 02-25-KVO[18650:5338623] ivar name：_work encode：@"NSString" 偏移量：24

2020-02-25 23:55:06.316930+0800 02-25-KVO[18650:5338623] ivar name：_numberOfStudent encode：q 偏移量：32

2020-02-25 23:55:06.317045+0800 02-25-KVO[18650:5338623] ==== OUTPUT:Teacher Method ====
2020-02-25 23:55:06.317152+0800 02-25-KVO[18650:5338623] method name:teachMethod
2020-02-25 23:55:06.317282+0800 02-25-KVO[18650:5338623] method name:numberOfStudent
2020-02-25 23:55:06.317512+0800 02-25-KVO[18650:5338623] method name:setNumberOfStudent:
2020-02-25 23:55:06.317796+0800 02-25-KVO[18650:5338623] method name:.cxx_destruct
2020-02-25 23:55:06.318045+0800 02-25-KVO[18650:5338623] method name:work
2020-02-25 23:55:06.318311+0800 02-25-KVO[18650:5338623] method name:setWork:
2020-02-25 23:55:06.318615+0800 02-25-KVO[18650:5338623] ==== OUTPUT:Teacher Protocols ====
2020-02-25 23:55:06.318824+0800 02-25-KVO[18650:5338623] =========================
2020-02-25 23:55:06.319773+0800 02-25-KVO[18650:5338623] LOG:(NSKVONotifying_Teacher) INFO
2020-02-25 23:55:06.319915+0800 02-25-KVO[18650:5338623] ==== OUTPUT:NSKVONotifying_Teacher properties ====
2020-02-25 23:55:06.320035+0800 02-25-KVO[18650:5338623] ==== OUTPUT:NSKVONotifying_Teacher Ivars ====
2020-02-25 23:55:06.320166+0800 02-25-KVO[18650:5338623] ==== OUTPUT:NSKVONotifying_Teacher Method ====
2020-02-25 23:55:06.320296+0800 02-25-KVO[18650:5338623] method name:setWork:
2020-02-25 23:55:06.320429+0800 02-25-KVO[18650:5338623] method name:setName:
2020-02-25 23:55:06.320695+0800 02-25-KVO[18650:5338623] method name:setAge:
2020-02-25 23:55:06.331496+0800 02-25-KVO[18650:5338623] method name:class
2020-02-25 23:55:06.331684+0800 02-25-KVO[18650:5338623] method name:dealloc
2020-02-25 23:55:06.331797+0800 02-25-KVO[18650:5338623] method name:_isKVOA
2020-02-25 23:55:06.331919+0800 02-25-KVO[18650:5338623] ==== OUTPUT:NSKVONotifying_Teacher Protocols ====
2020-02-25 23:55:06.332057+0800 02-25-KVO[18650:5338623] =========================
```



## Why like this?

## Summary

## Reference
