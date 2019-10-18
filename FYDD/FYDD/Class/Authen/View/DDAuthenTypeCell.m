//
//  DDAuthenTypeCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDAuthenTypeCell.h"

@implementation DDAuthenTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _applyButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _applyButton.layer.shadowOffset = CGSizeMake(0,3);
    _applyButton.layer.shadowRadius = 6;
    _applyButton.layer.shadowOpacity = 1;
    _applyButton.layer.cornerRadius = 20;
    
    [_exmaViews enumerateObjectsUsingBlock:^(UIView * obj,
                                             NSUInteger idx,
                                             BOOL * _Nonnull stop) {
        obj.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        obj.layer.shadowOffset = CGSizeMake(0,3);
        obj.layer.shadowRadius = 6;
        obj.layer.shadowOpacity = 1;
        obj.layer.cornerRadius = 10;
    }];
}

- (IBAction)menuButtonDidClick:(UIButton *)sender {
    if (_menuBlock) {
        _menuBlock(_userType,sender.tag);
    }
}

- (IBAction)applyButtonDidClick:(UIButton *)sender {
    if (_applyBlock) {
        _applyBlock(_userType);
    }
    
}

- (IBAction)shouquanButtonDidCick:(UIButton *)sender {
    if (_authorizeBlock) {
        _authorizeBlock(_userType);
    }
    
}

- (void)setUserType:(DDUserType)userType{
    _userType = userType;
    _applyButton.hidden = YES;
    _shouquanshuButton.hidden = YES;
    _examinationView.hidden = YES;
    _verifyView.hidden = YES;
    _startExaminationButton.userInteractionEnabled = NO;
    UIView * exSView = _exmaViews[1];
    exSView.backgroundColor = [UIColor whiteColor];
    switch (userType) {
        case DDUserTypeOnline: {
            
            _nameLb.text = @"实施方";
            _textLb1.text = @"软件实施工程师，制造业IT人员";
            _textLb2.text = @"完成订单可取的实施佣金";
            _iconView.image = [UIImage imageNamed:@"icon_user_type3"];
            if ([DDUserManager share].user.isAuth == -10){
                _applyButton.hidden = NO;
            }else if ([DDUserManager share].user.isAuth == 1) {
                _examinationView.hidden = NO;
                       [_verifyView setBackgroundImage:[UIImage imageNamed:@"icon_change_user3"] forState:UIControlStateNormal];
                exSView.backgroundColor = UIColorHex(0xf0f0f0);
                _startExaminationButton.userInteractionEnabled = NO;
                [_verifyView setTitle:@"已认证" forState:UIControlStateNormal];
                _verifyView.hidden = NO;
                _shouquanshuButton.hidden = NO;
            }else {
                _examinationView.hidden = NO;
                _verifyView.hidden = NO;
                       [_verifyView setBackgroundImage:[UIImage imageNamed:@"icon_change_user2"] forState:UIControlStateNormal];
                _startExaminationButton.userInteractionEnabled = YES;
                [_verifyView setTitle:@"未认证" forState:UIControlStateNormal];
            }
        }break;
            
        case DDUserTypePromoter:{
            _nameLb.text = @"代理方";
            _textLb1.text = @"推荐三特产品给用户使用";
            _textLb2.text = @"推荐成功可取得推广佣金";
            _iconView.image = [UIImage imageNamed:@"icon_user_type2"];
            if ([DDUserManager share].user.isExtensionUser == 0) {
                _applyButton.hidden = NO;
            }else if ([DDUserManager share].user.isExtensionUser == 1) {
                _examinationView.hidden = NO;
                _verifyView.hidden = NO;
                [_verifyView setBackgroundImage:[UIImage imageNamed:@"icon_change_user3"] forState:UIControlStateNormal];
                exSView.backgroundColor = UIColorHex(0xf0f0f0);
                _startExaminationButton.userInteractionEnabled = NO;
                [_verifyView setTitle:@"已认证" forState:UIControlStateNormal];
                _shouquanshuButton.hidden = NO;
            }else  {
                _examinationView.hidden = NO;
                _verifyView.hidden = NO;
                [_verifyView setBackgroundImage:[UIImage imageNamed:@"icon_change_user2"] forState:UIControlStateNormal];
                _startExaminationButton.userInteractionEnabled = YES;
                [_verifyView setTitle:@"未认证" forState:UIControlStateNormal];
            }
        }break;
            
        default:
            break;
    }
}


@end
