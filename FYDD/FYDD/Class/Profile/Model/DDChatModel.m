//
//  DDChatModel.m
//  FYDD
//
//  Created by mac on 2019/4/15.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDChatModel.h"
#import <YYKit/YYKit.h>

@implementation DDChatModel
- (void)layout{
    // 计算高度
    if (_replyType == 1){
        _height = [_message sizeForFont:[UIFont systemFontOfSize:12] size:CGSizeMake(kScreenSize.width - 178, 5000) mode:NSLineBreakByWordWrapping].height + 80;
        if (_height < 80) {
            _height = 80;
        }
    }else {
        _height = 192;
    }
    _createDate = [_createDate stringByReplacingOccurrencesOfString:@"" withString:@"+0000"];
    _createDate = [_createDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    if ([_createDate componentsSeparatedByString:@"."].count > 0) {
        _createDate = [_createDate componentsSeparatedByString:@"."][0];
    }
}
@end
