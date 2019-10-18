//
//  DDOrderCPICell.m
//  FYDD
//
//  Created by mac on 2019/4/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderCPICell.h"

@implementation DDOrderCPICell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfo:(DDOrderDetailInfo *)info{
    _info = info;
    _orderNumberLb.text = [NSString stringWithFormat:@"订单号: %@",_info.orders.orderNumber];
    _orderDateLb.text = [NSString stringWithFormat:@"订单日期: %@",[self getDateFormat:_info.orders.createDate]];
    _nameLb.text = info.orders.productName;
    if (yyTrimNullText(_info.orders.implementationPhone).length > 0) {
        _nameLb1.text = [NSString stringWithFormat:@"%@ %@",info.orders.implementationName,info.orders.implementationPhone];
    }else {
        _nameLb1.text = [NSString stringWithFormat:@"上线实施-%@",yyTrimNullText(_info.onlineMemberName)];
    }
    
    _moneyLb1.text = [NSString stringWithFormat:@"软件费用:¥%.f",_info.orders.productAmount];
    _moneLb2.text = [NSString stringWithFormat:@"实施费用:¥%.f",_info.orders.implementationCost];
    _moneLb3.text = [NSString stringWithFormat:@"费用合计:¥%.f",_info.orders.paymentAmount];
    _dayLb.text = [NSString stringWithFormat:@"%zd个月",_info.orders.productUseTime];
    
}

- (NSString *)getDateFormat:(NSString *)date{
    if (yyTrimNullText(date).length == 0) {
        return @"";
    }
    NSArray * dateLists = [date componentsSeparatedByString:@"T"];
    if (dateLists.count) {
        return dateLists[0];
    }
    return @"";
}


@end
