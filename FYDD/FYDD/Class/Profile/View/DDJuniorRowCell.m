//
//  DDJuniorRowCell.m
//  FYDD
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDJuniorRowCell.h"

@implementation DDJuniorRowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DDJuniorModel *)model{
    _model = model;
    _usernameLb.text = model.name;
    if ([yyTrimNullText(model.name) length] == 0) {
        _usernameLb.text = model.userName;
    }
    _countLb.text = [NSString stringWithFormat:@"%zd",model.orderNum];
    _moneyLb.text = [NSString stringWithFormat:@"%.2f",model.orderCountMoney];
//    if (yyTrimNullText(model.userHeadImage) && [yyTrimNullText(model.userHeadImage) hasPrefix:@"http"]) {
//        [_iconView sd_setImageWithURL:[NSURL URLWithString:model.userHeadImage]];
//    }
}

@end
