//
//  DDUserAgreeInfoCell.m
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDUserAgreeInfoCell.h"

@implementation DDUserAgreeInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    _iconView.image = [UIImage imageNamed:isSelected ?  @"icon_choose_s" : @"icon_choose_u"];
}
- (IBAction)btnDidClick:(id)sender {
    if (_event) {
        _event();
    }
}

@end
