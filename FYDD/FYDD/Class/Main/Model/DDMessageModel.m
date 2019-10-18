//
//  DDMessageModel.m
//  FYDD
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDMessageModel.h"

@implementation DDMessageModel
- (void)layout{
    if ([_createTime rangeOfString:@"."].location != NSNotFound) {
        _createTime = [[_createTime componentsSeparatedByString:@"."] firstObject];
        _createTime = [_createTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }
 
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"messageId":@"id"};
}
@end
