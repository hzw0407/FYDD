//
//  DDHistoryMoneyCell.m
//  FYDD
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDHistoryMoneyCell.h"

@implementation DDHistoryMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(DDBankModelHistoryModel *)item{
    _item = item;
    _bankNameLb.text = [NSString stringWithFormat:@"余额提现-到%@ (%@)",yyTrimNullText(_item.bankType),item.bankNo];
    _bankDateLb.text = item.bankTime;
    _moneLb.text = item.amount;
}

@end
