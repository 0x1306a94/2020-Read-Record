//
//  BusinessModule.h
//  03-08-DesignPatternLearning
//
//  Created by pmst on 2020/3/8.
//  Copyright © 2020 pmst. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BusinessModule;
typedef void(^CompletionBlock)(BOOL handled);
typedef void(^ResultBlock)(BusinessModule *module, BOOL handled);

@interface BusinessModule : NSObject
@property (nonatomic, strong) BusinessModule *nextModule;

- (void)handle:(ResultBlock)result;

- (void)handleBusiness:(CompletionBlock)completion;

@end

