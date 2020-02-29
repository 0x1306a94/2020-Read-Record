//
//  ViewController.m
//  02-29-FPSLabel
//
//  Created by pmst on 2020/2/29.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "ViewController.h"
#import "FPSLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FPSLabel *fpsLabel = [[FPSLabel alloc] initWithFrame:CGRectMake(100, 100, 80, 40)];
    fpsLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:fpsLabel];
    
    UIButton *workButton = [UIButton buttonWithType:UIButtonTypeSystem];
    workButton.frame = CGRectMake(100, 200, 80, 40);
    [workButton setTitle:@"工作" forState:UIControlStateNormal];
    [workButton addTarget:self action:@selector(doWork) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:workButton];
    
}

- (void)doWork {
    NSLog(@"开始工作");
    for (int i = 0; i < 1000; i++) {
        NSLog(@"doing");
    }
    NSLog(@"完成工作");
}

@end
