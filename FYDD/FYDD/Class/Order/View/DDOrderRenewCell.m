//
//  DDOrderRenewCell.m
//  FYDD
//
//  Created by mac on 2019/4/29.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderRenewCell.h"

@implementation DDOrderRenewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfo:(DDOrderDetailInfo *)info{
    _info = info;
    _orderNumberLb.text = [NSString stringWithFormat:@"订单编号:%@",info.orders.orderNumber];
    _orderDateLb.text = @"";
    
    NSString * dateText = [info.orders.orderDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dateText = [dateText  stringByReplacingOccurrencesOfString:@".000+0000" withString:@""];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * date =  [formatter dateFromString:dateText];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"yyyy-MM-dd HH:mm";
    
    _orderDateLb.text = [NSString stringWithFormat:@"订单日期:%@",[formatter1 stringFromDate:date]];
    _textLb4.hidden = NO;
    _textLb5.hidden = NO;

    NSString * dateText5 = [self getDateFormat:info.orders.dueDate];
    NSString * dateText6 = [self getDateFormat:info.orders.nextBalanceDate];
    _textLb4.text = [NSString stringWithFormat:@"到期日期: %@",dateText5];
    _textLb5.text = [NSString stringWithFormat:@"下个费用结算日: %@",dateText6];
}

- (NSString *)getDateFormat:(NSString *)date{
    if (yyTrimNullText(date).length == 0) {
        return @"";
    }
    NSArray * dateLists = [date componentsSeparatedByString:@" "];
    if (dateLists.count) {
        return dateLists[0];
    }
    return @"";
}
@end
