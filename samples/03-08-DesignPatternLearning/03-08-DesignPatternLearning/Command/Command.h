//
//  Command.h
//  03-08-DesignPatternLearning
//
//  Created by pmst on 2020/3/8.
//  Copyright © 2020 pmst. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Command;
typedef void(^CommandCompletionCallBack)(Command* cmd);

@interface Command : NSObject
@property (nonatomic, copy) CommandCompletionCallBack completion;

- (void)execute;

- (void)cancel;

- (void)done;
@end
