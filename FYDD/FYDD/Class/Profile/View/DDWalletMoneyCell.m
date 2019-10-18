//
//  DDWalletMoneyCell.m
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDWalletMoneyCell.h"

@implementation DDWalletMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(DDWalletModel *)item{
    _item = item;
    NSString * attMax = [NSString stringWithFormat:@"%@%.f",item.typeFlag,item.amount];
    NSString * date = item.createDate;
    date = [date stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    date = [date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    if ([date componentsSeparatedByString:@" "].count > 0) {
        _dateLb.text = [date componentsSeparatedByString:@" "][0];
    }else {
        _dateLb.text = @"";
    }
    
    // 失败
    _typeLb.text = item.typeName;
    if ([yyTrimNullText(_item.status) isEqualToString:@"3"]) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:attMax attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName: UIColorHex(0xaaaaaa),NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)}];
        _moneyLb.attributedText = string;
    // 成功
    }else if ([yyTrimNullText(_item.status) isEqualToString:@"2"]) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:attMax attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName: UIColorHex(0xE95F3A)}];
        _moneyLb.attributedText = string;
    }else {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:attMax attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName: UIColorHex(0x193750)}];
        _moneyLb.attributedText = string;
    }

}

@end
