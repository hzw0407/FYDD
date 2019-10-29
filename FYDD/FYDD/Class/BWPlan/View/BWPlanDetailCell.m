//
//  BWPlanDetailCell.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "BWPlanDetailCell.h"

@implementation BWPlanDetailCell

- (IBAction)orderButtonDidClick:(UIButton *)sender {
    if (_orderDidClick) {
        _orderDidClick();
    }
}

- (void)setPlanModel:(BWPlanModel *)planModel{
    _planModel = planModel;
    _userNameLb.text = planModel.legalUser;
    
    _companyLb.text = planModel.customerName;
    _shishiLb.text = planModel.customerStatus;
    _userNumberLb.text = [NSString stringWithFormat:@"%zd",_planModel.companyNumber];
    _versionLb.text = _planModel.categoriesName;
    _moneyLb.text = planModel.orderAccount > 0 ? [NSString stringWithFormat:@"%.2f",planModel.orderAccount] : @"";
    _orderLb.text = [NSString stringWithFormat:@"%@",yyTrimNullText(planModel.orderNumber)];
    _CheckLabel.hidden = yyTrimNullText(planModel.orderNumber).length > 0 ? NO : YES;
    _soialCodeLb.text = [NSString stringWithFormat:@"%@",planModel.customerCreditCode];
    _hanyLb.text = [NSString stringWithFormat:@"%@",planModel.customerIndustry];
    _dateLb1.text = [NSString stringWithFormat:@"%@",[yyTrimNullText(planModel.beginTime) formateServiceDate]];
    _dateLb2.text = [NSString stringWithFormat:@"%@",[yyTrimNullText(planModel.startTime) formateServiceDate]];
    _dateLb3.text = [NSString stringWithFormat:@"%@",[yyTrimNullText(planModel.deliverTime) formateServiceDate]];
    _dateLb4.text = [NSString stringWithFormat:@"%@",[yyTrimNullText(planModel.paymentTime) formateServiceDate]];
    _contactNaneLb.text = yyTrimNullText(_planModel.contactsName);
    _contactPhoneLb.text = yyTrimNullText(_planModel.contactsTelephone);
}
@end
