//
//  DDClerkOrderCell.m
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDClerkOrderCell.h"
#import <FSCalendar/FSCalendar.h>

@implementation DDClerkOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _orderBottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    _orderBottomView.layer.shadowOffset = CGSizeMake(0,6);
    _orderBottomView.layer.shadowRadius = 7;
    _orderBottomView.layer.shadowOpacity = 1;
    _orderBottomView.layer.cornerRadius = 5;
}

- (void)setInfo:(DDOrderInfo *)info{
    _info = info;
    _companyNameLb.text = info.enterpriseName;
    _typeLb.text = info.productName;
    _statusLb.text = info.orderStatusMessage;
    _orderNoLb.text = info.orderNumber;
    if (_info.productUseTime == -1 || !info.isCompanyFirst) {
        _remainLb.text = @"永久";
    }else {
        _remainLb.text = [NSString stringWithFormat:@"%zd天",info.productUseTime];
    }
    
    _dateLb.text = [self dateFormat:yyTrimNullText(info.createDate)];
    if (_info.implementationCost == 0) {
        _lastPriceLb.text = @"免费";
    }else {
            _lastPriceLb.text = [NSString stringWithFormat:@"¥%.2f",info.productAmount + info.implementationCost];
    }

}

- (NSString *)dateFormat:(NSString *)date{
    NSString * dateText = yyTrimNullText(date);
    if (dateText.length > 0) {
        dateText = [dateText stringByReplacingOccurrencesOfString:@".000+0000" withString:@""];
        dateText = [dateText stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSArray * comdate = [dateText componentsSeparatedByString:@" "];
        if (comdate.count > 0) {
            return  comdate[0];
        }
    }
    return @"";
}

@end
