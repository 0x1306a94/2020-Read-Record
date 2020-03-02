//
//  ViewController.m
//  03-02-runtime-经典题目01
//
//  Created by pmst on 2020/3/2.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface A : NSObject
@property (copy) NSString *name;
@end

@implementation A
- (void)print {
    NSLog(@"%@", _name);
}
@end

@interface ViewController ()

@end

struct mc_objc_class {
    Class _Nonnull isa;
};

@implementation ViewController

- (void)learnMemoryLayout {
    int intV  = 0x12345678;
    long longV = 0x32;
    int *intPT = &intV;
    void *voidPT = &longV;
    printf("int value : %p\n",&intV);
    printf("longV value : %p\n",&longV);
    printf("int pt value : %p\n",&intPT);
    printf("voidPT pt value : %p\n",&voidPT);
    
    printf("int 指针的值 : %p\n",intPT);
    printf("voidPT 指针的值 : %p\n",voidPT);
}



- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *name = @"pmst";
    id cls = [A class]; // 相当于在栈上分配了一块内存 其实就8个字节 isa
    void *obj = &cls; // obj 指针变量存储了 cls 变量所在的栈地址， &obj 则是 obj 变量在栈上的地址。
    // obj 指针值就是 cls 所在的栈地址，内容是8字节的 isa 指针
    // *obj 指向了 A 类对象
    [((__bridge id)obj) print];
    
    
    // 两者一致
    printf("cls 地址：%p\n",&cls);
    printf("地址：%p\n",((struct mc_objc_class *)obj));
    
    // 两者一致
    NSLog(@"%p",[A class]);
    printf("类对象地址：%p\n",(*(struct mc_objc_class *)obj));
    
    
//    typedef struct objc_class *Class;
//    typedef struct objc_object *id;
    
}


@end
