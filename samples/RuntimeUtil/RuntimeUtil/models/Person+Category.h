//
//  Person+Category.h
//  RuntimeUtil
//
//  Created by pmst on 2020/3/15.
//  Copyright © 2020 pmst. All rights reserved.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (Category)
@property(nonatomic, strong)NSString *cate_name;
@end


@interface Teacher (Category)
@property(nonatomic, strong)NSString *cate_teachCourse;
@end

NS_ASSUME_NONNULL_END
