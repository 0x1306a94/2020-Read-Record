//
//  UIView+RoundedCorner.m
//  0223-hitTest
//
//  Created by pmst on 2020/2/23.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "UIView+RoundedCorner.h"

@implementation UIView (RoundedCorner)

- (UIImage *)pt_drawRectWithRoundedCorderWithRadius:(CGFloat)radius
                                  borderWidth:(CGFloat)borderWidth
                               backgroudColor:(UIColor *)backgroudColor
                                  borderColor:(UIColor *)borderColor {
    CGSize sizeToFit = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    CGFloat halfBorderWidth = borderWidth/2.f;
    UIGraphicsBeginImageContextWithOptions(sizeToFit, false, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroudColor.CGColor);
    CGFloat width = sizeToFit.width;
    CGFloat height = sizeToFit.height;
    CGContextMoveToPoint(context, width - halfBorderWidth, radius + halfBorderWidth);
    CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width - radius - halfBorderWidth, height - halfBorderWidth, radius);
    CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radius - halfBorderWidth, radius);
    CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width - radius, halfBorderWidth, radius);
    CGContextAddArcToPoint(context, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, radius + halfBorderWidth, radius);
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

- (void)pt_addCorder:(CGFloat)radius {
    [self p_addCorder:radius borderWidth:1 backgroundColor:UIColor.redColor borderColor:UIColor.blackColor];
}

- (void)p_addCorder:(CGFloat)radius
         borderWidth:(CGFloat)borderWidth
     backgroundColor:(UIColor *)backgroundColor
         borderColor:(UIColor *)borderColor {
    UIImage *image = [self pt_drawRectWithRoundedCorderWithRadius:radius borderWidth:borderWidth backgroudColor:backgroundColor borderColor:borderColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self insertSubview:imageView atIndex:0];
}
@end
