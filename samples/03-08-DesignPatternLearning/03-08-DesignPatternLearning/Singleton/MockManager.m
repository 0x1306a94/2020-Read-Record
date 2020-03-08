//
//  MockManager.m
//  03-08-DesignPatternLearning
//
//  Created by pmst on 2020/3/8.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "MockManager.h"

@implementation MockManager

/**
 弱单例
 */

//+(instancetype)weakSharedInstance{
//    static __weak Singleton *weakInstance;
//    Singleton *instance = weakInstance;
//    @synchronized (self) {
//        if(!instance){
//            instance =[[Singleton alloc] init];
//            weakInstance = instance;
//        }
//    }
//    return instance;
//}

+ (instancetype)sharedInstance {
    // 静态局部变量
    static MockManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 平常用的最多的就是 [[self alloc] init];
        // 弱单例
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

// 重写方法【必不可少】
+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

// 重写方法【必不可少】
- (id)copyWithZone:(nullable NSZone *)zone{
    return self;
}
@end
