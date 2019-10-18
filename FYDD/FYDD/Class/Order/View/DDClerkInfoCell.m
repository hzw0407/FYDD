//
//  DDClerkInfoCell.m
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDClerkInfoCell.h"

@implementation DDClerkInfoCell

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setType:(NSInteger)type{
    _type = type;
    if (_type == -1) {
        _widthView.width = 0;
        for (NSInteger i = 0 ; i < _circleLbs.count; i++){
            UILabel * textLb = _circleLbs[i];
            UIImageView * imageView = _circleViews[i];
            textLb.textColor = UIColorHex(0xC6CFD6);
            imageView.image = [UIImage imageNamed:@"icon_cir_d"];
        }
    }else {
        for (NSInteger i = 0 ; i < _circleLbs.count; i++){
            UILabel * textLb = _circleLbs[i];
            UIImageView * imageView = _circleViews[i];
            if (type >= i) {
                textLb.textColor = UIColorHex(0x549BF3);
                imageView.image = [UIImage imageNamed:@"icon_cir_s"];
            }else {
                textLb.textColor = UIColorHex(0xC6CFD6);
                imageView.image = [UIImage imageNamed:@"icon_cir_d"];
            }
        }
        _widthView.width = ((kScreenSize.width - 64) / 4) * type;
    }
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
    _textLb2.hidden = NO;
    _textLb3.hidden = NO;
    _textLb4.hidden = NO;
    _textLb5.hidden = NO;
    if ([info.orders.orderStatus isEqualToString:@"070"]) {
        [self setType:4];
    }else if ([info.orders.orderStatus isEqualToString:@"060"]){
        [self setType:3];
    }else if ([info.orders.orderStatus isEqualToString:@"050"] ||
              [info.orders.orderStatus isEqualToString:@"040"]){
        [self setType:2];
    }else if ([info.orders.orderStatus isEqualToString:@"030"] ||
              [info.orders.orderStatus isEqualToString:@"020"] ||
              [info.orders.orderStatus isEqualToString:@"031"]){
        [self setType:1];
        _textLb2.hidden = YES;
        _textLb3.hidden = YES;
        _textLb4.hidden = YES;
        _textLb5.hidden = YES;
    }else if ([info.orders.orderStatus isEqualToString:@"010"] ||
              [info.orders.orderStatus isEqualToString:@"021"]){
        [self setType:0];

    }else {
        [self setType:-1];
    }
    
    NSString * dateText1 = [self getDateFormat:info.orders.dispatchDate];
    NSString * dateText2 = [self getDateFormat:info.orders.serviceDate];
    NSString * dateText3 = [self getDateFormat:info.orders.deploymentStartDate];
    NSString * dateText4 = [self getDateFormat:info.orders.deploymentEndDate];
    NSString * dateText5 = [self getDateFormat:info.orders.dueDate];
    NSString * dateText6 = [self getDateFormat:info.orders.nextBalanceDate];
    
    _textLb1.text = [NSString stringWithFormat:@"派单日期: %@",dateText1];
    if (dateText2.length == 0) {
        _textLb2.text = @"服务日期: ";
    }else {
        _textLb2.text = [NSString stringWithFormat:@"服务日期: %@",dateText2];
    }
    if (dateText3.length) {
        _textLb3.text = [NSString stringWithFormat:@"部署时长: %@ 至 %@",dateText3,dateText4];
    }else {
        _textLb3.text = @"部署时长: ";
    }
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
