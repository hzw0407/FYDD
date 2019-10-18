//
//  DDClerkTopCell.m
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
#import "DDClerkTopCell.h"
#import <Masonry/Masonry.h>

@interface DDClerkTopCell()
@property (nonatomic,strong)UIButton * tempBtn;
@end

@implementation DDClerkTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [DDAppManager share].appTintColor;
    _cons.constant = ((kScreenSize.width - 210) / 3) * (0.5);
    
    DDUser * user =  [DDUserManager share].user;
    switch (user.userType) {
        case DDUserTypeOnline:{
            self.starView.type = 1;
            self.starView.progress = 2.5;
            self.starView.userInteractionEnabled = false;
        }break;
            
        case DDUserTypeSystem:{
            _moneLb.text = user.realAuthentication ? @"已认证" : @"未认证";
            _industryNameLb.text = yyTrimNullText(user.industry);
            _companyLb.text = yyTrimNullText(user.enterpriseName);
        }break;
            
        case DDUserTypePromoter:
            break;
        default:
            break;
    }
    _tempBtn = _nextButton;
}

- (IBAction)buttonDidClick:(UIButton *)sender {
    sender.selected = YES;
    _tempBtn.selected = NO;
    _cons.constant = ((kScreenSize.width - 210) / 3) * (sender.tag  + 0.5) + sender.tag * 70;
    
    [self.contentView layoutIfNeeded];
    if (_event) {
        _event(sender.tag);
    }
    _tempBtn = sender;
}


@end
