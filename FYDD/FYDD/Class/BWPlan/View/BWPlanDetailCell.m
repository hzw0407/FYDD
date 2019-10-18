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
    if ([planModel.customerStatus isEqualToString:@"030"]) {
        _shishiLb.text = @"进行中";
    }else if ([planModel.customerStatus isEqualToString:@"060"]) {
        _shishiLb.text = @"实施中";
    }else if ([planModel.customerStatus isEqualToString:@"090"]) {
        _shishiLb.text = @"已完成";
    }
    _userNumberLb.text = [NSString stringWithFormat:@"%zd",_planModel.companyNumber];
    _versionLb.text = _planModel.categoriesName;
    _moneyLb.text = [NSString stringWithFormat:@"%.2f",planModel.orderAccount];
    _orderLb.text = [NSString stringWithFormat:@"%@",yyTrimNullText(planModel.orderNumber)];
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
