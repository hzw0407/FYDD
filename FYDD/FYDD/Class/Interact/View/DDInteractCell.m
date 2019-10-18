//
//  DDInteractCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDInteractCell.h"

@implementation DDInteractCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInteractObj:(DDInteractObj *)interactObj{
    _interactObj = interactObj;
    _nameLb.text = interactObj.title;
    _contentTextLb.text = interactObj.contents;
    if (yyTrimNullText(interactObj.createUserLogo).length > 0) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:yyTrimNullText(interactObj.createUserLogo)]];
    }else {
        _iconView.image = [UIImage imageNamed:[DDUserManager share].userPlaceImage];
    }
    if ([interactObj.createTime componentsSeparatedByString:@" "].count >0 ) {
        _dateLb.text = [interactObj.createTime componentsSeparatedByString:@" "][0];
    }
    _commentLb.text = [NSString stringWithFormat:@"%zd",interactObj.commentNumber];
}


@end
