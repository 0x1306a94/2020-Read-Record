//
//  ViewController.m
//  02-24-KVC
//
//  Created by pmst on 2020/2/24.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "ViewController.h"
@interface Person : NSObject{
    @public
    NSString *_name;
    NSString *_isName;
    NSString *name;
    NSString *isName;
}
@end

@implementation Person
//MARK: - setKey
- (void)setName:(NSString *)name{
    NSLog(@"%s - %@",__func__,name);
}
- (void)_setName:(NSString *)name{
    NSLog(@"%s - %@",__func__,name);
}

//MARK: - valueForKey 流程分析 - get<Key>, <key>, is<Key>, or _<key>,
- (NSString *)getName{
    return NSStringFromSelector(_cmd);
}
- (NSString *)name{
    return NSStringFromSelector(_cmd);
}
- (NSString *)isName{
    return NSStringFromSelector(_cmd);
}
- (NSString *)_name{
    return NSStringFromSelector(_cmd);
}

+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"来了");
}
- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}
//MARK: 空置防崩溃
- (void)setNilValueForKey:(NSString *)key{
    NSLog(@"设置 %@ 是空值",key);
}
//MARK: - 键值验证 - 容错 - 派发 - 消息转发
- (BOOL)validateValue:(inout id  _Nullable __autoreleasing *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing  _Nullable *)outError{
    if([inKey isEqualToString:@"name"]){
        [self setValue:[NSString stringWithFormat:@"里面修改一下: %@",*ioValue] forKey:inKey];
        return YES;
    }
    *outError = [[NSError alloc]initWithDomain:[NSString stringWithFormat:@"%@ 不是 %@ 的属性",inKey,self] code:10088 userInfo:nil];
    return NO;
}
@end
@interface ViewController ()

@end

@implementation ViewController

- (void)testSetKeyMethodProcedure {
    Person *person = [[Person alloc] init];
    // 查找顺序：
    // 找 set 方法，setKey => _setKey
    // accessInstanceVariablesDirectly 返回 NO，则直接报错 [setValue:forUndefinedKey:]
    // accessInstanceVariablesDirectly 返回 YES,
    // 查找实例变量： _key, _isKey key _isKey
    // Note: 对象.属性访问，本质是调用了setter方法
    [person setValue:@"pmst" forKey:@"name"];
    NSLog(@"\n_name:%@-_isName:%@-name:%@-isName%@",person->_name,person->_isName,person->name,person->isName);
    NSLog(@"\n_isName:%@-name:%@-isName:%@",person->_isName,person->name,person->isName);
    NSLog(@"\nname:%@-isName%@",person->name,person->isName);
    NSLog(@"\nisName:%@",person->isName);
}

- (void)testGetKeyMethodProcedure {
    Person *person = [[Person alloc] init];
    // 查找顺序(注释分别测试)：
    // 找 set 方法，getKey => Key => isKey => _Key
    // accessInstanceVariablesDirectly 返回 NO，则直接报错 [valueForUndefinedKey:]
    // accessInstanceVariablesDirectly 返回 YES,
    // 查找实例变量： _key, _isKey key _isKey，这个和 set 是一样的
    [person valueForKey:@"name"];
    
    // 依次注释 getName name isName _name 四个getter方法
    // 继续依次注释实例变量
    NSLog(@"取值:%@",[person valueForKey:@"name"]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testSetKeyMethodProcedure];
}


@end
