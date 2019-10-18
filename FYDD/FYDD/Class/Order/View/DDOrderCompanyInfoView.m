//
//  DDOrderCompanyInfoView.m
//  FYDD
//
//  Created by wenyang on 2019/9/6.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderCompanyInfoView.h"

@implementation DDOrderCompanyInfoView
- (void)awakeFromNib{
    [super awakeFromNib];
    _tempButton = _allButton;
    _topTintView.backgroundColor = [DDAppManager share].appTintColor;
    _menuView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    _menuView.layer.shadowOffset = CGSizeMake(0,3);
    _menuView.layer.shadowRadius = 6;
    _menuView.layer.shadowOpacity = 1;
    _menuView.layer.cornerRadius = 10;
    _lineView.centerX =  kScreenSize.width / 6 ;
    _statusLb.text = [DDUserManager share].user.realAuthentication ? @"已认证" : @"未认证";
    _statusLb.backgroundColor =[DDUserManager share].user.realAuthentication ?  UIColorHex(0x2996EB) :  UIColorHex(0x9A9A9A);
    _companyIndustryLb.text = yyTrimNullText([DDUserManager share].user.industry);
    _companyNameLb.text = yyTrimNullText([DDUserManager share].user.enterpriseName);
    
    NSString * iconURL = yyTrimNullText([DDUserManager share].user.userHeadImage);
    if ([iconURL hasPrefix:@"http"]) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:iconURL]];
    }else {
        _iconView.image = [UIImage imageNamed:[DDUserManager share].userPlaceImage];
    }
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


@end
