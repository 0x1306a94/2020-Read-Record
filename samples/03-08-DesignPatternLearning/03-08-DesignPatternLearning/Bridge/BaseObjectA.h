//
//  BaseObjectA.h
//  03-08-DesignPatternLearning
//
//  Created by pmst on 2020/3/8.
//  Copyright © 2020 pmst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObjectB.h"

@interface BaseObjectA : NSObject

@property (nonatomic, strong) BaseObjectB *objB;
- (void)handle;
@end


@interface ObjectA1 : BaseObjectA

@end


@interface ObjectA2 : BaseObjectA

@end
