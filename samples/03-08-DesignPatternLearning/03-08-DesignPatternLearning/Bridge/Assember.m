//
//  Assember.m
//  03-08-DesignPatternLearning
//
//  Created by pmst on 2020/3/8.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "Assember.h"
#import "BaseObjectA.h"
#import "BaseObjectB.h"

@interface Assember ()
@property (nonatomic, strong) BaseObjectA *objA;
@end

@implementation Assember

/*
 根据实际业务判断使用那套具体数据
 A1 --> B1、B2、B3         3种
 A2 --> B1、B2、B3         3种
 A3 --> B1、B2、B3         3种
 */
- (void)doSomthing {
    // 创建一个具体的ClassA
    _objA = [[ObjectA1 alloc] init];
    
    // 创建一个具体的ClassB
    BaseObjectB *b1 = [[ObjectB1 alloc] init];
    // 将一个具体的ClassB1 指定给抽象的ClassB
    _objA.objB = b1;
    
    // 获取数据
    [_objA handle];
}
@end
