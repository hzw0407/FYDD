
//
//  DDRequestMainObj.m
//  FYDD
//
//  Created by wenyang on 2019/9/3.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDRequestMainObj.h"
#import <YYKit/YYKit.h>
@implementation DDRequestMainObj
// 计算高度
- (void)layoutHeight{
    // 计算题目cell高度
   _titleHeight =   [yyTrimNullText(_title) sizeForFont:[UIFont systemFontOfSize:16] size:CGSizeMake(kScreenSize.width - 75, 100000) mode:NSLineBreakByWordWrapping].height + 23;
    if (_titleHeight < 45) {
        _titleHeight = 45;
    }
    // 计算高度
    _aSelectHeight = [self questionHeight:_aSelect];
    _bSelectHeight = [self questionHeight:_bSelect];
    _cSelectHeight = [self questionHeight:_cSelect];
    _dSelectHeight = [self questionHeight:_dSelect];
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"questionId":@"id"};
}


- (CGFloat)questionHeight:(NSString *)title {
    if (yyTrimNullText(title).length > 0) {
        return  [title sizeForFont:[UIFont systemFontOfSize:16] size:CGSizeMake(kScreenSize.width - 64, 10000) mode:NSLineBreakByWordWrapping].height + 22;
    }
    return 0;
}

@end
