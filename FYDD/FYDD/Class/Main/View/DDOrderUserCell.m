//
//  DDOrderUserCell.m
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderUserCell.h"

@implementation DDOrderUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_contactTd addTarget:self action:@selector(textChangeTarget) forControlEvents:UIControlEventEditingChanged];
    [_contactPhoneTd addTarget:self action:@selector(textChangeTarget1) forControlEvents:UIControlEventEditingChanged];
    [_userLb addTarget:self action:@selector(textChangeTarget3) forControlEvents:UIControlEventEditingChanged];
}

- (void)textChangeTarget {
    if (_textChange){
        _textChange(_contactTd.text,1);
    }
}

- (void)textChangeTarget1 {
    if (_textChange){
        _textChange(_contactPhoneTd.text,2);
    }
}

- (void)textChangeTarget3 {
    if (_textChange){
        _textChange(_userLb.text,0);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)searchButtonDidClick {
    if (_textBlock) {
        _textBlock(_userLb.text);
    }
}
- (IBAction)cityEvent:(id)sender {
    if (_event) {
        _event(1);
    }
}

- (IBAction)buttonDidClick:(UIButton *)sender {
    if (_event) {
        _event(2);
    }
}

- (void)setOnlineUser:(DDOnlineModel *)onlineUser{
    _onlineUser = onlineUser;
    if (onlineUser) {
        _nameLb1.hidden = NO;
        _nameLb2.hidden = NO;
        _nameLb3.hidden = NO;
        _circleView.hidden = NO;
        _nameLb1.text = onlineUser.userName;
        _nameLb2.text = onlineUser.userPhone;
        _nameLb3.text = [NSString stringWithFormat:@"%.1f",onlineUser.commissionFee];
        _circleView.image = [UIImage imageNamed:_onlineUser.isSelected ? @"icon_cir_s" : @"icon_cir_d"];
    }else {
        _nameLb1.hidden = YES;
        _nameLb2.hidden = YES;
        _nameLb3.hidden = YES;
        _circleView.hidden = YES;
    }
}


@end
