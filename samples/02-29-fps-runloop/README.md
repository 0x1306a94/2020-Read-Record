title: "FPS Runloop 监听两事件之间间隔"
date: 2020-02-29
tags: [APM]
categories: [APM]
keywords: APM,runloop
description: 简短描述。

<!--此处开始正文-->

## What is it?

[iOS实时卡顿监控](http://www.tanhao.me/code/151113.html/) 提出了监听 kCFRunLoopBeforeSources 和 kCFRunLoopAfterWaiting，然后利用信号量来判断是否卡顿，甚至可以捕获堆栈信息来查问题。

现在有几个问题需要理下：

1. 为什么是监听这两个事件；
2. 原理是什么？
3. 收集的卡顿堆栈是否及时，是否可以认为问题现场？

## How to use?

```objective-c

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

PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                                                   symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
NSData *data = [crashReporter generateLiveReport];
PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
NSString *report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter
                                                          withTextFormat:PLCrashReportTextFormatiOS];
```

## Why like this?

## Summary

## Reference
