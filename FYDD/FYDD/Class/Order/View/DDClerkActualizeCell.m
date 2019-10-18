//
//  DDClerkActualizeCell].m
//  FYDD
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDClerkActualizeCell.h"

@implementation DDClerkActualizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
    self.rateVierw.type = 1;
    
    self.rateVierw.userInteractionEnabled = false;
}

- (void)setInfo:(DDOrderDetailInfo *)info{
    _info = info;
    _nameLb.text = [NSString stringWithFormat:@"%@ %@",yyTrimNullText(info.orders.implementationName),yyTrimNullText(info.onlineMemberName)];
    
    NSMutableAttributedString *priceAtt = [NSMutableAttributedString new];
    
    NSMutableAttributedString *attribut1 = [[NSMutableAttributedString alloc]initWithString:@"实施费用 "];
    [attribut1 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                               NSForegroundColorAttributeName : UIColorHex(0xC6CFD6)} range:NSMakeRange(0,4)];
    
    NSString * text2 = [NSString stringWithFormat:@"¥%.f",_info.orders.implementationCost];
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
    
    self.rateVierw.progress = info.implementationScore;
    _phoneLb.text = [NSString stringWithFormat:@"联系方式:%@",yyTrimNullText(_info.orders.implementationPhone)];
    _percentLb.text = [NSString stringWithFormat:@"%.1f",info.implementationScore];
}

@end
