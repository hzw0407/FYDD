//
//  DDPayTypeView.m
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDPayTypeView.h"

@interface DDPayTypeView ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *iconView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLb;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *listView;

@end

@implementation DDPayTypeView


- (IBAction)payTypeButtonDidClick:(UIButton *)btn {
    if (_event){
        _event([btn superview].tag);
    }
}

- (void)setPayType:(DDAppPayType)payType{
    _payType = payType;
    NSMutableArray * dataList = @[].mutableCopy;
    // 钱包
    if (payType & DDAppPayTypeWallet) {
        [dataList addObject:@{@"icon" : @"pay_type", @"name" :@"钱包支付" , @"type" : @(DDAppPayTypeWallet)}];
    }
//    if (payType & DDAppPayTypeAlipay) {
//        [dataList addObject:@{@"icon" : @"pay_type2", @"name" :@"支付宝支付",@"type" : @(DDAppPayTypeAlipay)}];
//    }
//
//    if (payType & DDAppPayTypeWechat) {
//        [dataList addObject:@{@"icon" : @"pay_type1", @"name" :@"微信支付",@"type" : @(DDAppPayTypeWechat)}];
//    }
    
    if (payType & DDAppPayTypeBank) {
        [dataList addObject:@{@"icon" : @"pay_type3", @"name" :@"线下转账",@"type" : @(DDAppPayTypeBank)}];
    }

    for (NSInteger i = 0 ; i < dataList.count ; i ++) {
        NSDictionary * dic = dataList[i];
        UIView * view = _listView[i];
        view.hidden =  NO;
        UIImageView * iconView = _iconView[i];
        iconView.image = [UIImage imageNamed:dic[@"icon"]];
        UILabel * textLb = _nameLb[i];
        textLb.text = dic[@"name"];
        view.tag = [dic[@"type"] integerValue];
    }
}

@end
