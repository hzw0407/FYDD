//
//  DDFootstripObj.m
//  FYDD
//
//  Created by wenyang on 2019/9/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDFootstripObj.h"
#import <YYKit/YYKit.h>

@implementation DDFootstripObj
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"objId":@"id"};
}

- (void)layout{
    _cellHeight = 65;
    _titleHeight = [yyTrimNullText(_title) sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(kScreenSize.width - 30, 10000) mode:NSLineBreakByWordWrapping].height + 10;
    if (_titleHeight < 40) {
        _titleHeight = 40;
    }
    _contentHeight  = [yyTrimNullText(_contents) sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(kScreenSize.width - 30, 10000) mode:NSLineBreakByWordWrapping].height + 10;
    if (_contentHeight < 20) {
        _contentHeight = 20;
    }
    
    
    double height = 0;
    NSArray * showImage = [_showImage componentsSeparatedByString:@"|"];
    switch (showImage.count) {
        case 1:
            _imageSize = CGSizeMake(kScreenSize.width - 20, kScreenSize.width - 20);
            height = kScreenSize.width - 20;
            break;
        case 2:
        case 3:
        case 4:{
            _imageSize = CGSizeMake((kScreenSize.width - 30) / 2, (kScreenSize.width - 30) / 2);
            NSInteger line = (showImage.count + 1) /2;
            height = _imageSize.height * line + line * 10;
        }break;
        default:
            _imageSize = CGSizeMake((kScreenSize.width - 40) / 3, (kScreenSize.width - 40) / 3);
            NSInteger line = (showImage.count + 2) /3;
            height = _imageSize.height * line + line * 10;
            break;
    }
    _cellHeight += _titleHeight;
    _cellHeight += _contentHeight;
    if ([_contents rangeOfString:@"<"].location == NSNotFound) {
        _cellHeight += height;
    }
    
    
}
@end

@implementation DDFootstripComment
- (void)layout{
    _titleHeight = [_commnet sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(kScreenSize.width - 74, 100000) mode:NSLineBreakByWordWrapping].height + 60;
    if (_titleHeight < 90) {
        _titleHeight = 90;
    }
    
    _laxHeight = [_commnet sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(kScreenSize.width - 120, 100000) mode:NSLineBreakByWordWrapping].height + 60;
    if (_titleHeight < 90) {
        _titleHeight = 90;
    }
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"commentId":@"id"};
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"comments": [DDFootstripComment class]};
}

@end
