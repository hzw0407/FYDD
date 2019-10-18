//
//  DDOpportunityCell.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOpportunityCell.h"

@implementation DDOpportunityCell

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

- (void)setModel:(DDOpportunityModel *)model{
    _model = model;
    _companyLb.text = model.customerName;
    _orderLb.text = [NSString stringWithFormat:@"订单号: %@",model.orderNumber];
    _scoialLb.text = [NSString stringWithFormat:@"统一社会信用代码: %@",model.customerCreditCode];
    _hangyeLb.text = [NSString stringWithFormat:@"版本: %@   行业: %@",yyTrimNullText(model.categoriesName),yyTrimNullText(model.customerIndustry)];
    _dateLb1.text = [NSString stringWithFormat:@"开始日期: %@   启动日期: %@",[yyTrimNullText(model.beginTime) formateServiceDate],[yyTrimNullText(model.startTime) formateServiceDate]];
    _dateLb2.text = [NSString stringWithFormat:@"交付日期: %@   付款日期: %@",[yyTrimNullText(model.deliverTime) formateServiceDate],[yyTrimNullText(model.paymentTime) formateServiceDate]];
}

- (IBAction)renLinButtonDidClick:(UIButton *)sender {
    if (_renLinBlock) {
        _renLinBlock();
    }
}

@end
