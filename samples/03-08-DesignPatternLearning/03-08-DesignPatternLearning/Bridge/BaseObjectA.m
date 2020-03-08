//
//  BaseObjectA.m
//  03-08-DesignPatternLearning
//
//  Created by pmst on 2020/3/8.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "BaseObjectA.h"

@implementation BaseObjectA
 /*
    A1 --> B1、B2、B3         3种
    A2 --> B1、B2、B3         3种
    A3 --> B1、B2、B3         3种
  */
- (void)handle {
    // override to subclass
    
    [self.objB fetchData];
}
@end


@implementation ObjectA1

- (void)handle {
    // 重写
    NSLog(@"ObjectB1 fetch data");
}
@end

@implementation ObjectA2

- (void)handle {
    // before 业务逻辑操作
    
    [super handle];
    
    // after 业务逻辑操作
}
@end
