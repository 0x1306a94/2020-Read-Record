//
//  GroupObject.m
//  03-05-GCD-learning01
//
//  Created by pmst on 2020/3/5.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "GroupObject.h"

@interface GroupObject ()
{
    dispatch_queue_t concurrent_queue;
    NSMutableArray <NSURL *> *arrayURLs;
}
@end

@implementation GroupObject
- (instancetype)init {
    self = [super init];
    if (self) {
        concurrent_queue = dispatch_queue_create("download_images_queue", DISPATCH_QUEUE_CONCURRENT);
        arrayURLs = [NSMutableArray array];
    }
    return self;
}

- (void)excuteDownloadTask {
    dispatch_group_t group = dispatch_group_create();
    
    for (NSURL *url in arrayURLs) {
        dispatch_group_async(group, concurrent_queue, ^{
            NSLog(@"download image for %@",url);
        });
    }
    dispatch_group_notify(group, concurrent_queue, ^{
        NSLog(@"download all images");
    });
}
@end
