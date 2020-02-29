//
//  ViewController.m
//  02-29-fps-runloop
//
//  Created by pmst on 2020/2/29.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "ViewController.h"
#import "APMCenter.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [APMCenter.center startMonitor];
    
    UIButton *workButton = [UIButton buttonWithType:UIButtonTypeSystem];
    workButton.frame = CGRectMake(100, 200, 80, 40);
    [workButton setTitle:@"工作" forState:UIControlStateNormal];
    [workButton addTarget:self action:@selector(doWork) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:workButton];
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    int x = 0;
    NSNumber *res = nil;
    for (int i = 0; i < 200; i++) {
        for (int j = 0; j <100; j++) {
            for (int k = 0; k< 100; k++) {
                x = i * 2 + j * 3;
                x += 2;
                x = k/2.f + x/3.f;
                res = [NSNumber numberWithDouble:x];
            }
        }
    }
//    NSLog(@"%@",res);
    cell.textLabel.text = [NSString stringWithFormat:@"index %d 单元格",indexPath.row];
    return cell;
}

- (void)doWork {
    NSLog(@"开始工作");
    for (int i = 0; i < 10000; i++) {
        NSLog(@"doing");
    }
    NSLog(@"完成工作");
}

@end
