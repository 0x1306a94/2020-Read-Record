//
//  ViewController.m
//  0223-copy-mutablecopy
//
//  Created by pmst on 2020/2/23.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
// 赋值给别人
@property(nonatomic, strong)NSMutableArray *marr_s_1;
@property(nonatomic, copy)NSMutableArray *marr_c_1;
@property(nonatomic, strong)NSArray *arr_s_1;
@property(nonatomic, copy)NSArray *arr_c_1;

// 别的地方赋值给属性
@property(nonatomic, strong)NSMutableArray *marr_s_2;
@property(nonatomic, copy)NSMutableArray *marr_c_2;
@property(nonatomic, strong)NSArray *arr_s_2;
@property(nonatomic, copy)NSArray *arr_c_2;

@end

@implementation ViewController


- (void)test:(id)obj {
    NSArray *array1 = [obj copy];
    NSArray *array2 = [obj mutableCopy];
    NSLog(@"\norigin:%p,\narray1:%p,\narray2:%p",obj,array1,array2);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.marr_s_1 = [NSMutableArray arrayWithArray:@[@1,@2]];
    [self test:self.marr_s_1]; // strong 对象我本身是可以变化的，所以 copy mutable 都要分配内存
    
    self.marr_c_1 = [NSMutableArray arrayWithArray:@[@1,@2,@3]];
    [self test:self.marr_c_1]; // copy 属性修饰的数组 内部copy地址不变, mutable汇编
    
    self.arr_s_1 = @[@1,@2];
    [self test:self.arr_s_1];
    
    self.arr_c_1 = @[@1,@2,@3];
    [self test:self.arr_c_1];
    
    // ============================================
    NSArray *array = @[@1,@2,@3,@4];
    
    self.marr_s_2 = array; // 全部一样
    self.marr_c_2 = array;
    self.arr_s_2 = array;
    self.arr_c_2 = array;
    NSLog(@"\narray赋值给四个属性\norigin:%p\nms2:%p\nmc2:%p\ns2:%p\nc2:%p\n",array,self.marr_s_2,self.marr_c_2,self.arr_s_2,self.arr_c_2);
    NSMutableArray *mutableArray =  [NSMutableArray arrayWithArray:@[@1,@2,@100]];
    
    self.marr_s_2 = mutableArray; // 不变
    self.marr_c_2 = mutableArray; // 重新分配内存 深copy 不可变
    self.arr_s_2 = mutableArray; // 不变
    self.arr_c_2 = mutableArray; // 重新分配内存 深copy 不可变
    NSLog(@"\nmutablearray赋值给四个属性\norigin:%p\nms2:%p\nmc2:%p\ns2:%p\nc2:%p\n",mutableArray,self.marr_s_2,self.marr_c_2,self.arr_s_2,self.arr_c_2);
}


@end
