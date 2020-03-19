//
//  main.m
//  TestWeak
//
//  Created by pmst on 2020/3/18.
//  Copyright © 2020 pmst. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSObject *p = [[NSObject alloc] init];
        __weak NSObject *p1 = p;
    }
    return 0;
}
