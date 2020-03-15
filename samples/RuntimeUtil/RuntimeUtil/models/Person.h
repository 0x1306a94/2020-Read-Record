//
//  Person.h
//  RuntimeUtil
//
//  Created by pmst on 2020/3/15.
//  Copyright © 2020 pmst. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Person : NSObject
@property(nonatomic, strong)NSString *name;
@end



@interface Teacher : Person
@property(nonatomic, strong)NSString *teachCourse;

@end

