//
//  DDOrderCarryView.m
//  FYDD
//
//  Created by wenyang on 2019/9/6.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderCarryView.h"

@implementation DDOrderCarryView

- (void)awakeFromNib{
    [super awakeFromNib];
    _tempButton = _allButton;
    self.rateView.type = 1;
    self.rateView.userInteractionEnabled = false;
    _topTintView.backgroundColor = [DDAppManager share].appTintColor;
    _menuView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    _menuView.layer.shadowOffset = CGSizeMake(0,3);
    _menuView.layer.shadowRadius = 6;
    _menuView.layer.shadowOpacity = 1;
    _menuView.layer.cornerRadius = 10;
}

- (IBAction)topButtonDidClick:(UIButton *)sender {
    sender.selected = YES;
    _tempButton.selected = NO;
    _lineView.centerX = (sender.tag + 0.5) * kScreenSize.width / 3 ;
    
    [self layoutIfNeeded];
    if (_event) {
        _event(sender.tag);
    }
    _tempButton = sender;
    
}

//设置实施方数据
- (void)setCheckUser:(DDOrderCheckUser *)checkUser{
    _checkUser = checkUser;
    self.scoreLb.text = [NSString stringWithFormat:@"%.2f",[checkUser.totlaScore doubleValue]];
    self.rateView.progress = [checkUser.totlaScore doubleValue];
    _moneyLb.text = [NSString stringWithFormat:@"¥%@",checkUser.totalIncome];
    _statusLB.backgroundColor = UIColorHex(0x9A9A9A);
    [self.ingButton setTitle:@"进行中" forState:UIControlStateNormal];
    [self.finishButton setTitle:@"已完成" forState:UIControlStateNormal];
    if([DDUserManager share].user.isOnlineUser == 0) {
        _statusLB.text = @"未申请";
    }else if([DDUserManager share].user.isOnlineUser == 1) {
        _statusLB.text = @"已认证";
        _statusLB.backgroundColor = UIColorHex(0x2996EB);
    }else if([DDUserManager share].user.isOnlineUser == 2) {
        _statusLB.text = @"未认证";
//        _statusLB.backgroundColor = UIColorHex(0x2996EB);
    }else if([DDUserManager share].user.isOnlineUser == 3) {
        _statusLB.text = @"未通过";
    }
    _iconView.image = [UIImage imageNamed:@"icon_user_type2"];
    NSString * iconURL = yyTrimNullText([DDUserManager share].user.userHeadImage);
    if ([iconURL hasPrefix:@"http"]) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:iconURL]];
    }else {
        _iconView.image = [UIImage imageNamed:[DDUserManager share].userPlaceImage];
    }
}

//设置代理方数据
- (void)setExtensionUser:(DDOrderExtensionUser *)extensionUser{
    _extensionUser = extensionUser;
    self.scoreLb.text = [NSString stringWithFormat:@"%.2f",[extensionUser.totalScore doubleValue]];
    self.rateView.progress = [extensionUser.totalScore doubleValue];
    _statusLB.backgroundColor = UIColorHex(0x9A9A9A);
    [self.ingButton setTitle:@"我的订单" forState:UIControlStateNormal];
    [self.finishButton setTitle:@"下线订单" forState:UIControlStateNormal];
    if([DDUserManager share].user.isExtensionUser == 0) {
        _statusLB.text = @"未申请";
    }else if([DDUserManager share].user.isExtensionUser == 1) {
        _statusLB.text = @"已认证";
        _statusLB.backgroundColor = UIColorHex(0x2996EB);
    }else if([DDUserManager share].user.isExtensionUser == 2) {
        _statusLB.text = @"未认证";
    }else if([DDUserManager share].user.isExtensionUser == 3) {
        _statusLB.text = @"未通过";
    }
    _moneyLb.text = [NSString stringWithFormat:@"¥%@",extensionUser.totalIncome];
    _iconView.image = [UIImage imageNamed:@"icon_user_type3"];
    NSString * iconURL = yyTrimNullText([DDUserManager share].user.userHeadImage);
    if ([iconURL hasPrefix:@"http"]) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:iconURL]];
    }else {
        _iconView.image = [UIImage imageNamed:[DDUserManager share].userPlaceImage];
    }
}


@end
