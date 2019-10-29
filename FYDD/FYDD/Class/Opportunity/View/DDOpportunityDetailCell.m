//
//  DDOpportunityDetailCell.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOpportunityDetailCell.h"

@implementation DDOpportunityDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rateView.type = 1;
    self.rateView.progress = 0;
}

- (void)setAppModel:(DDOpportunityModel *)appModel{
    _appModel = appModel;
    _userNameLb.text = appModel.legalUser;
    _companyLb.text = appModel.customerName;
    _userNumberLb.text = [NSString stringWithFormat:@"%zd",_appModel.companyNumber];
    _moneyLb.text = [NSString stringWithFormat:@"%.2f",appModel.orderAccount];
    _orderLb.text = [NSString stringWithFormat:@"%@",appModel.orderNumber];
    _soialCodeLb.text = [NSString stringWithFormat:@"%@",appModel.customerCreditCode ? appModel.customerCreditCode : @""];
    _hanyLb.text = [NSString stringWithFormat:@"%@",appModel.customerIndustry ? appModel.customerIndustry : @""];
    _dateLb1.text = [NSString stringWithFormat:@"%@",[yyTrimNullText(appModel.beginTime) formateServiceDate]];
    _dateLb2.text = [NSString stringWithFormat:@"%@",[yyTrimNullText(appModel.startTime) formateServiceDate]];
    _dateLb3.text = [NSString stringWithFormat:@"%@",[yyTrimNullText(appModel.deliverTime) formateServiceDate]];
    _dateLb4.text = [NSString stringWithFormat:@"%@",[yyTrimNullText(appModel.paymentTime) formateServiceDate]];
    _contactLb.text = yyTrimNullText(appModel.contactsName);
    _contantPhoneLb.text = yyTrimNullText(appModel.contactsTelephone);
}
- (IBAction)oderDetailDidClick:(UIButton *)sender {
    if (_orderBtnBlock) {
        _orderBtnBlock();
    }
}

- (IBAction)renLinButtonDidClick:(UIButton *)sender {
    if (_renlinBlock) {
        _renlinBlock();
    }
}
@end
