//
//  BaseObjectB.m
//  03-08-DesignPatternLearning
//
//  Created by pmst on 2020/3/8.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "BaseObjectB.h"

@implementation BaseObjectB

- (void)fetchData {
    NSLog(@"fetch data");
}
@end


@implementation ObjectB1

- (void)fetchData {
    NSLog(@"ObjectB1 fetch data");
}
@end

@implementation ObjectB2

- (void)fetchData {
    NSLog(@"ObjectB2 fetch data");
}
@end
