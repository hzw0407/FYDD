//
//  BWPlanCell.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "BWPlanCell.h"
#import "NSString+DDString.h"
@implementation BWPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bottomView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    _bottomView.layer.borderWidth = 0.5;
    _bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,3);
    _bottomView.layer.shadowRadius = 6;
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.cornerRadius = 10;
}

- (void)setPlanModel:(BWPlanModel *)planModel{
    _planModel = planModel;
    _companyLb.text = yyTrimNullText(planModel.customerName);
    _statusLb.text = yyTrimNullText(planModel.customerStatus);
    _orderLb.text = [NSString stringWithFormat:@"订单号: %@",yyTrimNullText(planModel.orderNumber) ? yyTrimNullText(planModel.orderNumber) : @""];
    _scoialLb.text = [NSString stringWithFormat:@"统一社会信用代码: %@",yyTrimNullText(planModel.customerCreditCode)];
    _BanBenlabel.text = [NSString stringWithFormat:@"版本: %@",yyTrimNullText(planModel.categoriesName) ? yyTrimNullText(planModel.categoriesName) : @""];
    _HangYeLabel.text = [NSString stringWithFormat:@"行业: %@",yyTrimNullText(planModel.customerIndustry)];
    _dateLb1.text = [NSString stringWithFormat:@"添加日期: %@   注册日期: %@",[yyTrimNullText(planModel.beginTime) formateServiceDate],[yyTrimNullText(planModel.startTime) formateServiceDate]];
    _dateLb2.text = [NSString stringWithFormat:@"付款日期: %@",[yyTrimNullText(planModel.paymentTime) formateServiceDate]];
    _dayLb.text =  [NSString stringWithFormat:@"保质期: %zd天",_planModel.planExpireDay];
    _dayLb.hidden = NO;
    if (_planModel.planExpireDay == -1) {
        _dayLb.hidden = YES;
        _dateLb2.text = [NSString stringWithFormat:@"付款日期: %@",[yyTrimNullText(planModel.paymentTime) formateServiceDate]];
    }
    
    if([planModel.customerStatus isEqualToString:@"待审核"] ||
       [planModel.customerStatus isEqualToString:@"审核拒绝"]) {
        _dayLb.hidden = YES;
    }
}
@end
