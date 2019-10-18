//
//  DDReceiptTypeCell.m
//  FYDD
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDReceiptTypeCell.h"

@interface DDReceiptTypeCell()
@property (nonatomic,weak) UIButton * temp;

@end

@implementation DDReceiptTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _button1.titleLabel.numberOfLines = 0;
    _button2.titleLabel.numberOfLines = 0;
    [self setButtonSelected:_button1 selected:YES];
    [self setButtonSelected:_button2 selected:NO];
}

- (void)setButtonSelected:(UIButton *)btn selected:(BOOL)selected{
    btn.layer.borderColor = selected ? UIColorHex(0x549BF3).CGColor : UIColorHex(0xC6CFD6).CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 3;
    btn.clipsToBounds = YES;
    btn.selected = selected;
    if (selected){
        _temp = btn;
    }
}


- (IBAction)buttonDidClick:(UIButton *)sender {
    [self setButtonSelected:_temp selected:NO];
    [self setButtonSelected:sender selected:YES];
    if (_event) {
        _event(sender.tag);
    }
}

@end
