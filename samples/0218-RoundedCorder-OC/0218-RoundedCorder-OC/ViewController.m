//
//  ViewController.m
//  0218-RoundedCorder-OC
//
//  Created by pmst on 2020/2/18.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "ViewController.h"
#import "UIView+RoundedCorner.h"
#import "UIImage+RoundedCorder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    [view pt_addCorder:10];
    [self.view addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avator.jpg"]];
    imageView.frame = CGRectMake(100, 100, 100, 100);
    [imageView pt_addCorner: 6];
    [self.view addSubview:imageView];
}


@end
