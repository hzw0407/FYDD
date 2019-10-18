//
//  DDClerkMenuView.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDClerkMenuView.h"

@implementation DDClerkMenuView

- (void)awakeFromNib{
    [super awakeFromNib];
    _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,3);
    _bottomView.layer.shadowRadius = 6;
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.cornerRadius = 25;
}

- (IBAction)aidButtonClick:(UIButton *)sender {
    if (_clertButtonClick) {
        _clertButtonClick(sender.tag);
    }
}

- (void)reloadView{
    self.button2.hidden = NO;
    _iconView2.hidden = NO;

    BOOL isVeify = NO;
    switch ([DDUserManager share].user.userType) {
        case DDUserTypeOnline:{
        
        }break;
        case DDUserTypeSystem:
            isVeify = YES;
//            self.button2.hidden = YES;
//            _iconView2.hidden = YES;
//            self.button1.frame = _bottomView.bounds;
//            _iconView1.centerY = _bottomView.size.height * 0.4;
            break;
        case DDUserTypePromoter: {
            
        }break;
        default:
            break;
    }
    _bottomView.frame = _bottomView.bounds;
    if ([DDUserManager share].user.isAuth == 1 &&
        [DDUserManager share].user.isExtensionUser == 1) {
        isVeify = YES;
    }
    if (isVeify) {
        self.button2.hidden = YES;
        _iconView2.hidden = YES;
        _bottomView.frame = CGRectMake(0, 0, _bottomView.frame.size.width, self.frame.size.height * 0.5);

    }
}

@end
