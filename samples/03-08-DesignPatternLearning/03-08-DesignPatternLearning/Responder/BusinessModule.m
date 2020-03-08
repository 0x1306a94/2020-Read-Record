//
//  BusinessModule.m
//  03-08-DesignPatternLearning
//
//  Created by pmst on 2020/3/8.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "BusinessModule.h"

@implementation BusinessModule

- (void)handle:(ResultBlock)result {
    
    CompletionBlock completion = ^(BOOL handled){
        if (handled) {
            result(self, handled);
        } else {
            if (self.nextModule) {
                [self.nextModule handle:result];
            } else {
                result(nil, NO);
            }
        }
    };
    
    [self handleBusiness:completion];
}

- (void)handleBusiness:(CompletionBlock)completion {
    
}
@end
