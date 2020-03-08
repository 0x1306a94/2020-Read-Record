//
//  WrapperedTarget.m
//  03-08-DesignPatternLearning
//
//  Created by pmst on 2020/3/8.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "WrapperedTarget.h"

@interface WrapperedTarget ()
@property (nonatomic, strong)OldTarget *target;
@end

@implementation WrapperedTarget

- (instancetype)initWithTarget:(OldTarget *)target {
    self = [super init];
    if (self) {
        _target = target;
    }
    return self;
}

- (void)freshAPI {
    // do something before
    
    [self.target oldOperation];
    
    // do something after
}
@end
