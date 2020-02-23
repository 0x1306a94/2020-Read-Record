title: "Hit-Testing 寻找最佳响应者"
date: 2020-02-23
tags: [UI事件响应]
categories: [基础知识]
keywords: UI事件响应
description: Hit-Testing 寻找最佳响应者。

<!--此处开始正文-->

## What is it?

hitTest 是 UI 中事件响应链的重要知识点，核心方法是 hitTest 和 pointInside 方法。

## How to use?

```objective-c
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{ 
    // 1. 前置条件要满足       
    if (self.userInteractionEnabled == NO || 
    self.hidden == YES ||  
    self.alpha <= 0.01) return nil;
  
  	// 2. 判断点是否在视图内部 这是最起码的 note point 是在当前视图坐标系的点位置
    if ([self pointInside:point withEvent:event] == NO) return nil;

  	// 3. 现在起码能确定当前视图能够是响应者 接下去询问子视图
    int count = (int)self.subviews.count;
    for (int i = count - 1; i >= 0; i--) {
      // 子视图
        UIView *childView = self.subviews[i];
    
    // 点需要先转换坐标系        
        CGPoint childP = [self convertPoint:point toView:childView];  
        // 子视图开始询问
        UIView *fitView = [childView hitTest:childP withEvent:event]; 
        if (fitView)
        {
      		return fitView;
    		}
    }
                         
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat x1 = point.x;
    CGFloat y1 = point.y;
    
    CGFloat x2 = self.frame.size.width / 2;
    CGFloat y2 = self.frame.size.height / 2;
    
    double dis = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
    // 67.923
    if (dis <= self.frame.size.width / 2) {
        return YES;
    }
    else{
        return NO;
    }
}
```

## Why like this?

## Summary

## Reference

* [iOS Touch Event from the inside out](https://www.jianshu.com/p/70ba981317b6)