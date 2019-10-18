//
//  DDOrderStatusCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderStatusCell.h"

@implementation DDOrderStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _statusDictButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _statusDictButton.layer.shadowOffset = CGSizeMake(0,3);
    _statusDictButton.layer.shadowRadius = 6;
    _statusDictButton.layer.shadowOpacity = 1;
}
- (IBAction)shenheButtonDidClick:(UIButton *)sender {
    if (_comfirmBlock) {
        _comfirmBlock();
    }
}

- (IBAction)showButtonDidClick:(UIButton *)sender {
    if (_explandBlock) {
        _explandBlock();
    }
}

- (void)setDetailObj:(DDOrderDetailObj *)detailObj{
    _detailObj = detailObj;
    
    NSArray * textLbs = @[@"待付款",@"待接单",@"服务中",@"实施步骤",@"待评价",@"已完成"];
    NSArray * imageName = @[@"icon_status_img5",@"icon_status_img1",@"icon_status_img2",@"icon_status_img3",@"icon_status_img4", @"icon_status_img6"];
    if (detailObj.isCompanyFirst) {
        textLbs = @[@"待接单",@"服务中",@"实施步骤",@"待评价",@"待付款",@"已完成"];
        imageName = @[@"icon_status_img1",@"icon_status_img2",@"icon_status_img3",@"icon_status_img4",@"icon_status_img5", @"icon_status_img6"];;
    }
    
    NSInteger i = 0;
    switch (detailObj.orderStatusType) {
        case DDOrderStatusOrderTaking:
        case DDOrderStatusLeaflets: {
            i = 1;
            if (detailObj.isCompanyFirst)i = 0;
        }break;
        case DDOrderStatusService:
            i = 2;
            if (detailObj.isCompanyFirst) i = 1;
            break;
        case DDOrderStatusCarry:
        case DDOrderStatusChangeCarryUser:
            i = 3;
            if (detailObj.isCompanyFirst) i = 2;
            break;
        case DDOrderStatusWaitComment:
            i = 4;
            if (detailObj.isCompanyFirst) i = 3;
            break;
        case DDOrderStatusFinish:
            i = 5;
            break;
        case DDOrderStatusWaitPay:
        case DDOrderStatusPay:
        case DDOrderStatusPayFail:
            i = 0;
            if (detailObj.isCompanyFirst) i = 4;
            break;
        case DDOrderStatusPaySuccess:
            i = 1;
            if (detailObj.isCompanyFirst) i = 0;
            break;
        default:
            break;
    }
    [_statusDictButton setImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateNormal];
    for (NSInteger j =0; j < _statusLbs.count;j++) {
        UILabel * tdLb = _statusLbs[j];
        tdLb.text = textLbs[j];
        UIView * cirleView = _cirleViews[j];
        
        if (i >= j) {
            cirleView.backgroundColor = UIColorHex(0x2996EB);
            tdLb.textColor = UIColorHex(0x2996EB);
        }else {
            cirleView.backgroundColor = UIColorHex(0xABAEB1);
            tdLb.textColor = UIColorHex(0xABAEB1);
        }
        if (i == j ) {
            tdLb.font = [UIFont systemFontOfSize:14];
            _statusDictButton.centerX = tdLb.centerX;
        }else {
            tdLb.font = [UIFont systemFontOfSize:12];
        }
    }
    
    _statusLineView.width = i * (kScreenSize.width - 52) / 5 - 8;
    _statusLineView.left = 33;
    _statusDictButton.hidden = NO;
}

- (void)setPlanModel:(DDOrderPlanModel *)planModel{
    _planModel = planModel;
    if (!_planModel) {
        return;
    }
    _numberLb.text = [NSString stringWithFormat:@"%zd",planModel.step];
    _stepNameLB.text = planModel.detailTitle;
    _stepButton.userInteractionEnabled = NO;
    if ([DDUserManager share].user.userType == DDUserTypeSystem) {
        if ([yyTrimNullText(_planModel.status) isEqualToString:@"0"]) {
            [_stepButton setTitle:@"审核" forState:UIControlStateNormal];
            _stepButton.layer.borderWidth = 1;
            _stepButton.layer.borderColor = UIColorHex(0xEF8200).CGColor;
            _stepButton.selected = YES;
            _stepButton.userInteractionEnabled = YES;
            _stepButton.layer.cornerRadius = 15;
            return;
        }
    }
    [_stepButton setTitle:planModel.statusName forState:UIControlStateNormal];
    
}

@end
