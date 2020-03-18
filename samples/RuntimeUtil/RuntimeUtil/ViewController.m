//
//  ViewController.m
//  RuntimeUtil
//
//  Created by pmst on 2020/3/15.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "PTRuntimeUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)test_class_copyIvarList_and_class_copyPropertyList {
    [[PTRuntimeUtil new] logClassInfo:Person.class];
    [[PTRuntimeUtil new] logClassInfo:Teacher.class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = [NSArray array];
    NSMutableArray *marray = (NSMutableArray *)array;
    [marray addObject:@(1)];
}


@end
