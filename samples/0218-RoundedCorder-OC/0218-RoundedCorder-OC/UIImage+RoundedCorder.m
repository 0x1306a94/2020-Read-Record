//
//  UIImage+RoundedCorder.m
//  0218-RoundedCorder-OC
//
//  Created by pmst on 2020/2/18.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "UIImage+RoundedCorder.h"


@implementation UIImage (RoundedCorder)
- (UIImage *)pt_drawRectWithRoundedCornerWithRadius:(CGFloat)radius
                                          sizeToFit:(CGSize)sizeToFit {
    CGRect rect = CGRectMake(0, 0, sizeToFit.width, sizeToFit.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return output;
}

@end

@implementation UIImageView (RoundedCorder)

- (void)pt_addCorner:(CGFloat)radius {
    self.image = [self.image pt_drawRectWithRoundedCornerWithRadius:radius sizeToFit:self.bounds.size];
}

@end
