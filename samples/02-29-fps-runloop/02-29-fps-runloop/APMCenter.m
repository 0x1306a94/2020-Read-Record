//
//  APMCenter.m
//  02-29-fps-runloop
//
//  Created by pmst on 2020/3/1.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "APMCenter.h"

@interface APMCenter () {
    @public
    CFRunLoopObserverRef observer;
    CFRunLoopActivity activity;
    dispatch_semaphore_t semaphore;
    NSInteger timeoutCount;
}

@end

@implementation APMCenter

+ (instancetype)center {
    static APMCenter *instance = nil;
    if (!instance) {
        instance = [[APMCenter alloc] init];
    }
    
    return instance;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer,  CFRunLoopActivity activity, void *info) {
    APMCenter *center = (__bridge APMCenter*)info;
    center->activity = activity;
    dispatch_semaphore_t semaphore = center->semaphore;
    dispatch_semaphore_signal(semaphore);
    return;
    if (center->activity & kCFRunLoopEntry) {
        NSLog(@"[%d] kCFRunLoopEntry",(int)center->activity);
    } else if (center->activity & kCFRunLoopBeforeTimers){
        NSLog(@"[%d] kCFRunLoopBeforeTimers",(int)center->activity);
    } else if (center->activity & kCFRunLoopBeforeSources){
        NSLog(@"[%d] kCFRunLoopBeforeSources",(int)center->activity);
    } else if (center->activity & kCFRunLoopBeforeWaiting){
        NSLog(@"[%d] kCFRunLoopBeforeWaiting",(int)center->activity);
    } else if (center->activity & kCFRunLoopAfterWaiting){
       NSLog(@"[%d] kCFRunLoopAfterWaiting",(int)center->activity);
    } else if (center->activity & kCFRunLoopExit){
        NSLog(@"[%d] kCFRunLoopExit",(int)center->activity);
    }
    

}

- (void)startMonitor {
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    
    self->observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
                                       
    CFRunLoopAddObserver(CFRunLoopGetMain(), self->observer, kCFRunLoopCommonModes);

    self->semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            long st = dispatch_semaphore_wait(self->semaphore, dispatch_time(DISPATCH_TIME_NOW, 20*NSEC_PER_MSEC));
            if (st != 0) {
                if (!self->observer) {
                    self->timeoutCount = 0;
                    self->semaphore = 0;
                    self->activity = 0;
                    return;
                }
                
                if (self->activity==kCFRunLoopBeforeSources || self->activity==kCFRunLoopAfterWaiting) {
//                    NSLog(@"timeout count :%d",self->timeoutCount + 1);
                    if (++self->timeoutCount < 5)
                        continue;
                    NSLog(@"好像有点儿卡哦");
                }
            }
            self->timeoutCount = 0;
        }
    });
}
@end
