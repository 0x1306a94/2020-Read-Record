//
//  ViewController.m
//  03-27-autoreleasepool
//
//  Created by pmst on 2020/3/27.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "ViewController.h"

static void RunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NSLog(@"activity:%d",activity);
}

__weak id obj;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSThread detachNewThreadSelector:@selector(createAndConfigObserverInSecondaryThread2) toTarget:self withObject:nil];
}

- (void)createAndConfigObserverInSecondaryThread {
    __autoreleasing id test = [NSObject new];
   NSLog(@"obj = %@", test);
   obj = test;
   [[NSThread currentThread] setName:@"test runloop thread"];
   NSLog(@"thread ending");
}

- (void)createAndConfigObserverInSecondaryThread2 {
    [[NSThread currentThread] setName:@"test runloop thread"];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    CFRunLoopObserverRef observer;
    observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                       kCFRunLoopAllActivities,
                                       true,      // repeat
                                       0xFFFFFF,  // after CATransaction(2000000)
                                       RunLoopObserverCallBack, NULL);
    CFRunLoopRef cfrunloop = [loop getCFRunLoop];
    if (observer) {
        CFRunLoopAddObserver(cfrunloop, observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    }
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(testAction) userInfo:nil repeats:YES];
    [loop run];
    NSLog(@"thread ending");
}

- (void)testAction{
    __autoreleasing id test = [NSObject new];
    obj = test;
    NSLog(@"obj = %@", obj);
}


@end
