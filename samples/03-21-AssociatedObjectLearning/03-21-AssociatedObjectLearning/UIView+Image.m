//
//  UIView+Image.m
//  03-21-AssociatedObjectLearning
//
//  Created by pmst on 2020/3/21.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "UIView+Image.h"
#import <objc/runtime.h>

static NSString * const kKeyOfImageProperty;

@implementation UIView (Image)

- (UIImage *)pt_image {
    return objc_getAssociatedObject(self, &kKeyOfImageProperty);
}

- (void)setPTImage:(UIImage *)image {
    objc_setAssociatedObject(self, &kKeyOfImageProperty, image,OBJC_ASSOCIATION_RETAIN);
}
@end
