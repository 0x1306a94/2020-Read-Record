//
//  WrapperedTarget.h
//  03-08-DesignPatternLearning
//
//  Created by pmst on 2020/3/8.
//  Copyright © 2020 pmst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OldTarget.h"

@interface WrapperedTarget : NSObject

- (instancetype)initWithTarget:(OldTarget *)target;

- (void)freshAPI;

@end
