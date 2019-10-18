//
//  DDOrderPayInfoCell.m
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderPayInfoCell.h"

@implementation DDOrderPayInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0,3);
    _bottomView.layer.shadowRadius = 6;
    _bottomView.layer.shadowOpacity = 1;
    _bottomView.layer.cornerRadius = 10;
    
    NSMutableAttributedString *priceAtt = [NSMutableAttributedString new];
    
    NSMutableAttributedString *attribut1 = [[NSMutableAttributedString alloc]initWithString:@"实施费用 "];
    [attribut1 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],
                               NSForegroundColorAttributeName : UIColorHex(0xC6CFD6)} range:NSMakeRange(0,4)];
    
    NSString * text2 = [NSString stringWithFormat:@"¥%@",@"8888.00"];
    NSMutableAttributedString *attribut2 = [[NSMutableAttributedString alloc]initWithString:text2];
    [attribut2 addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
                               NSForegroundColorAttributeName : UIColorHex(0x549BF3)} range:NSMakeRange(0,text2.length)];
    
    
    [priceAtt appendAttributedString:attribut1];
    [priceAtt appendAttributedString:attribut2];
    _priceLb1.attributedText = priceAtt;
    _priceLb2.attributedText = priceAtt;
    _priceLb3.attributedText = priceAtt;
}


- (void)setProductPrice:(double)price{
    _priceLb1.attributedText = [self getPriceAtt:price withName:@"软件费用 " color:UIColorHex(0x131313)];
}

- (void)setProductCost:(double)price{
    _priceLb2.attributedText = [self getPriceAtt:price withName:@"实施费用 " color:UIColorHex(0x131313)];
}

- (void)setTotalPrice:(double)price{
    _priceLb3.attributedText = [self getPriceAtt:price withName:@"费用合计 " color:UIColorHex(0xEF8200)];
}

-(NSMutableAttributedString *)getPriceAtt:(double)price withName:(NSString *)name color:(UIColor *)color{
    NSMutableAttributedString *priceAtt = [NSMutableAttributedString new];
    
    NSMutableAttributedString *attribut1 = [[NSMutableAttributedString alloc]initWithString:name];
    [attribut1 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],
                               NSForegroundColorAttributeName : UIColorHex(0xABAEB1)} range:NSMakeRange(0,name.length)];
    
    NSString * text2 = [NSString stringWithFormat:@"¥%.f",price];
    NSMutableAttributedString *attribut2 = [[NSMutableAttributedString alloc]initWithString:text2];
    [attribut2 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],
                               NSForegroundColorAttributeName : color} range:NSMakeRange(0,text2.length)];
    
    
    [priceAtt appendAttributedString:attribut1];
    [priceAtt appendAttributedString:attribut2];
    return priceAtt;
}

@end
