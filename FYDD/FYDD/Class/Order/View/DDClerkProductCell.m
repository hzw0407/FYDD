//
//  DDClerkProductCell.m
//  FYDD
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDClerkProductCell.h"

@implementation DDClerkProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.rateVierw.type = 1;
    self.clipsToBounds = YES;
    self.rateVierw.userInteractionEnabled = false;
}

- (void)setInfo:(DDOrderDetailInfo *)info{
    _info = info;
    _nameLb.text = info.orders.productName;
    
    NSMutableAttributedString *priceAtt = [NSMutableAttributedString new];
    
    NSMutableAttributedString *attribut1 = [[NSMutableAttributedString alloc]initWithString:@"软件费用 "];
    [attribut1 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                               NSForegroundColorAttributeName : UIColorHex(0xC6CFD6)} range:NSMakeRange(0,4)];
    
    NSString * text2 = [NSString stringWithFormat:@"¥%.f",info.orders.productAmount];
    NSMutableAttributedString *attribut2 = [[NSMutableAttributedString alloc]initWithString:text2];
    [attribut2 addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15],
                               NSForegroundColorAttributeName : UIColorHex(0x549BF3)} range:NSMakeRange(0,text2.length)];
    
    NSMutableAttributedString *attribut3 = [[NSMutableAttributedString alloc]initWithString:@"元"];
    [attribut3 addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
                               NSForegroundColorAttributeName : UIColorHex(0x8C9FAD)} range:NSMakeRange(0,1)];
    
    
    [priceAtt appendAttributedString:attribut1];
    [priceAtt appendAttributedString:attribut2];
    [priceAtt appendAttributedString:attribut3];
    _priceLb.attributedText = priceAtt;
    _userLb.text = [NSString stringWithFormat:@"代理方:%@",yyTrimNullText(_info.orders.extensionName)];
    self.rateVierw.progress = info.extensionScore;
    _percentLb.text = [NSString stringWithFormat:@"%.1f",info.extensionScore];
}

@end
