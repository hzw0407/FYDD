//
//  DDProductCell.m
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProductCell.h"
#import <UIImageView+WebCache.h>
@implementation DDProductCell

- (IBAction)buttonDidClick {
    if (_event) {
        _event(_indexPath.row);
    }
    _contentLb.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)setItem:(DDProductItem *)item{
    _item = item;

    _contentLb.text = item.contentText;
    _nameLb.text = item.productName;
    _cons.constant = item.cellHeight - 100;
    [self.contentView layoutIfNeeded];
    _priceLb.attributedText = item.priceAttr;
    if (_item.backImg) {
        [_backImageView sd_setImageWithURL:[NSURL URLWithString:_item.backImg]];
    }
}
@end
