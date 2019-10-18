//
//  DDOrderPlanModel.m
//  FYDD
//
//  Created by wenyang on 2019/9/6.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderPlanModel.h"
#import <YYKit/YYKit.h>

@implementation DDOrderPlanModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"modelId" : @"id"};
}

- (NSString *)statusName{
    if (yyTrimNullText(_status).length == 0) {
        return @"待实施";
    }else if ([yyTrimNullText(_status) isEqualToString:@"0"]) {
        return @"待审核";
    }else if ([yyTrimNullText(_status) isEqualToString:@"1"]) {
        return @"审核通过";
    }else {
        return @"驳回";
    }
}

- (void)layoutCons{
    _cellHeight = 195;
    _ideaHeight = 0;
    double height = [yyTrimNullText(_onlineRemarks) sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(kScreenSize.width - 60, 1000) mode:NSLineBreakByWordWrapping].height;
    if (height < 21) height = 21;
    if (yyTrimNullText(_onlineRemarks).length >0) {
        _ideaHeight1 = height + 5;
    }else {
        _ideaHeight1 = 0;
    }
    
    double height1 = [yyTrimNullText(_userDetail) sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(kScreenSize.width - 60, 1000) mode:NSLineBreakByWordWrapping].height;
    if (height1 < 21) height1 = 21;
    if (yyTrimNullText(_onlineRemarks).length >0) {
        _ideaHeight = height1 + 5;
    }else {
        _ideaHeight = 0;
    }
    
    NSMutableArray * datas = @[].mutableCopy;
    NSArray * images = [yyTrimNullText(_onlineContent) componentsSeparatedByString:@";"];
    for (NSInteger i =0; i < images.count ; i++) {
        NSString * url = images[i];
        if ([url rangeOfString:@"http"].location != NSNotFound) {
            [datas addObject:url];
        }
    }
    _imgs = datas;
    NSInteger line = (datas.count + 3) / 4;
    _imageWidth = (kScreenSize.width - 55 - 30) / 4;
    _imagesHeight =  line * _imageWidth + line * 10;
    
    _cellHeight = _cellHeight + _ideaHeight + _ideaHeight1 + _imagesHeight;
    
}

- (NSString *)convertEvaluate:(NSString *)eval{
    NSString * statuText = [NSString stringWithFormat:@"%@",eval];
    if ([statuText isEqualToString:@"3"]) {
        return @"满意";
    }else if ([statuText isEqualToString:@"5"]) {
        return @"非常满意";
    }else if ([statuText isEqualToString:@"4"]) {
        return @"比较满意";
    }else if ([statuText isEqualToString:@"2"]) {
        return @"一般";
    }else if ([statuText isEqualToString:@"1"]) {
        return @"一般般";
    }
    return @"";
}
@end
