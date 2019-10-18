//
//  DDIndustryModel.m
//  FYDD
//
//  Created by mac on 2019/3/28.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDIndustryModel.h"
#import <NSObject+YYModel.h>

@implementation DDIndustryModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"ddId":@"id"};
}
@end
