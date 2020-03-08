//
//  Command.m
//  03-08-DesignPatternLearning
//
//  Created by pmst on 2020/3/8.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "Command.h"
#import "CommandManager.h"

@implementation Command
- (void)execute {
    
    //override to subclass;
    
    [self done];
}

- (void)cancel {
    
    self.completion = nil;
}

- (void)done {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_completion) {
            _completion(self);
        }
        self.completion = nil;
        [[CommandManager sharedInstance].arrayCommands removeObject:self];
    });
}
@end
