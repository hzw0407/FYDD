//
//  DDOrderCarryCell.m
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderCarryCell.h"

@implementation DDOrderCarryCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _nextButton = _currentBtn;
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
}

- (void)setPrice:(double)price{
    _price = price ;
    NSMutableAttributedString *priceAtt = [NSMutableAttributedString new];
    
    NSMutableAttributedString *attribut1 = [[NSMutableAttributedString alloc]initWithString:@"实施费用 "];
    [attribut1 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],
                               NSForegroundColorAttributeName : UIColorHex(0xC6CFD6)} range:NSMakeRange(0,4)];
    
    NSString * text2 = [NSString stringWithFormat:@"¥%.f",price];
    NSMutableAttributedString *attribut2 = [[NSMutableAttributedString alloc]initWithString:text2];
    [attribut2 addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
                               NSForegroundColorAttributeName : UIColorHex(0x549BF3)} range:NSMakeRange(0,text2.length)];
    
    
    [priceAtt appendAttributedString:attribut1];
    [priceAtt appendAttributedString:attribut2];
    _priceLb.attributedText = priceAtt;
}

- (IBAction)buttonDidClick:(UIButton *)btn {
    _nextButton.selected = NO;
    btn.selected = YES;
    _nextButton = btn;
    for (UIButton * btn1 in _buttons) {
        btn1.selected = NO;
    }
    for (DDGradeModel * item in _items){
        item.isSelected = NO;
    }
    
    [_buttons[btn.tag] setSelected:YES];
    [_items[btn.tag] setIsSelected:YES];
    if (_event) {
        _event(btn.tag);
    }
}

- (void)setItems:(NSArray<DDGradeModel *> *)items{
    _items = items;
    for (NSInteger i = 0; i < items.count ; i++) {
        if (items.count < 4) {
            DDGradeModel * item = items[i];
            UILabel * moneyLb = _moneyLb1[i];
            moneyLb.text = [NSString stringWithFormat:@"%.f",item.commissionFee];
            UILabel * nameLb = _nameLb[i];
            nameLb.text = item.gradeName;
            UIButton * circleBtn = _buttons[i];
            circleBtn.selected = item.isSelected;
            circleBtn.hidden = NO;
        }
    }
}

- (IBAction)upButtonDidClick {
    if (_event) {
        _event(4);
    }
}

@end
