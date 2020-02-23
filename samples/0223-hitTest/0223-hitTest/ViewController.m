//
//  ViewController.m
//  0223-hitTest
//
//  Created by pmst on 2020/2/23.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "ViewController.h"
#import "CircleButton.h"
#import "UIView+RoundedCorner.h"

@interface ViewController ()
@property(nonatomic, strong)CircleButton *circleBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.circleBtn = [[CircleButton alloc] initWithFrame:CGRectMake(100, 100, 120, 120)];
    [self.circleBtn pt_addCorder:60];
    [self.circleBtn addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.circleBtn];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)doAction:(id)sender{
    NSLog(@"click");
}


@end
