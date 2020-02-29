//
//  FPSLabel.m
//  02-29-FPSLabel
//
//  Created by pmst on 2020/2/29.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "FPSLabel.h"


@interface WeakProxy : NSObject
@property(nonatomic, weak)NSObject *target;
@end

@implementation WeakProxy

- (instancetype)initWithTarget:(NSObject *)target {
    self = [super init];
    if (self) {
        _target = target;
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (_target) {
        return [_target respondsToSelector:aSelector];
    }
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _target;
}

@end

@interface FPSLabel ()
@property(nonatomic, strong)CADisplayLink *link;
@property(nonatomic, assign)NSInteger count;
@property(nonatomic, assign)CFTimeInterval lastTime;
@property(nonatomic, strong)UIFont *subFont;
@end

@implementation FPSLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (CGRectGetWidth(frame) == 0 || CGRectGetHeight(frame) == 0) {
        frame = CGRectMake(frame.origin.x, frame.origin.y, 55, 20);
    }
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = true;
        self.textAlignment = NSTextAlignmentCenter;
        [self setUserInteractionEnabled:false];
        self.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.7];
        
        if (self.font != nil) {
            _subFont = [UIFont fontWithName:@"Menlo" size:4];
        } else {
            self.font = [UIFont fontWithName:@"Courier" size:14];
            self.subFont = [UIFont fontWithName:@"Courier" size:4];
        }
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [self.link addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    }

    return self;
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    self.count += 1;
    CFTimeInterval timePassed = link.timestamp - _lastTime;
    
    if (timePassed < 1) {
        return;
    }
    self.lastTime = link.timestamp;
    CGFloat fps = (double)self.count / timePassed;
    self.count = 0;
    double progress = fps/60.f;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress-0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSString *content = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: content];
    [text addAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(0, text.length - 3)];
    [text addAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor} range:NSMakeRange(text.length - 3, 3)];
    [text addAttributes:@{NSFontAttributeName:self.font} range:NSMakeRange(0, text.length)];
    [text addAttributes:@{NSFontAttributeName:self.subFont} range:NSMakeRange(text.length - 4, 1)];
    self.attributedText = text;
}

- (void)dealloc {
    [self.link invalidate];
}

@end
