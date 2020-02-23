//
//  UIImage+RoundedCorner.m
//  0223-hitTest
//
//  Created by pmst on 2020/2/23.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "UIImage+RoundedCorner.h"
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
