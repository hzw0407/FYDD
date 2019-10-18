//
//  DDVideoListModel.m
//  FYDD
//
//  Created by mac on 2019/4/29.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDVideoListModel.h"

@implementation DDVideoListModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"videoId":@"id"};
}
@end
