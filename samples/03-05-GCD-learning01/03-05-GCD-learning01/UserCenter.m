//
//  UserCenter.m
//  03-05-GCD-learning01
//
//  Created by pmst on 2020/3/5.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "UserCenter.h"

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
