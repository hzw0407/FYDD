//
//  DDOrderProductInfoCell.m
//  FYDD
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderProductInfoCell.h"

@implementation DDOrderProductInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

}


- (void)setPrice:(double)price{
    _price = price;
    NSMutableAttributedString *priceAtt = [NSMutableAttributedString new];
    
    NSMutableAttributedString *attribut1 = [[NSMutableAttributedString alloc]initWithString:@"软件费用: "];
    [attribut1 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],
                               NSForegroundColorAttributeName : UIColorHex(0xC6CFD6)} range:NSMakeRange(0,4)];
    
    NSString * text2 = [NSString stringWithFormat:@"¥%.f",_price];
    NSMutableAttributedString *attribut2 = [[NSMutableAttributedString alloc]initWithString:text2];
    [attribut2 addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
                               NSForegroundColorAttributeName : UIColorHex(0x549BF3)} range:NSMakeRange(0,text2.length)];
    
    
    [priceAtt appendAttributedString:attribut1];
    [priceAtt appendAttributedString:attribut2];
    _priceLb.attributedText = priceAtt;
}


@end
