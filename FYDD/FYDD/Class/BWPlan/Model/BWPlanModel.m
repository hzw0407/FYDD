//
//  BWPlanModel.m
//  FYDD
//
//  Created by wenyang on 2019/9/2.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "BWPlanModel.h"

@implementation BWPlanModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"planId":@"id"};
}
@end
