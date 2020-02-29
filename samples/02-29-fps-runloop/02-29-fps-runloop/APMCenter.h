//
//  APMCenter.h
//  02-29-fps-runloop
//
//  Created by pmst on 2020/3/1.
//  Copyright © 2020 pmst. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMCenter : NSObject
+ (instancetype)center;
- (void)startMonitor;
@end

NS_ASSUME_NONNULL_END
