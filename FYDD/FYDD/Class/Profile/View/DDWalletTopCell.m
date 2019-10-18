//
//  DDWalletTopCell.m
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDWalletTopCell.h"


@interface DDWalletTopCell()
@property (nonatomic,strong)UIButton * tempBtn;
@end

@implementation DDWalletTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _tempBtn = _button1;
    _cons.constant = (kScreenSize.width / 6)  -17.5;
    _colorView.backgroundColor = [DDAppManager share].appTintColor;
    _walletMenuView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _walletMenuView.layer.shadowOffset = CGSizeMake(0,3);
    _walletMenuView.layer.shadowRadius = 6;
    _walletMenuView.layer.shadowOpacity = 1;
    _walletMenuView.layer.cornerRadius = 10;
}
- (IBAction)questionButtonClick:(UIButton *)sender {
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (IBAction)menButtonDidCLick:(UIButton *)sender {
    sender.selected = YES;
    _tempBtn.selected = NO;
    _cons.constant = sender.center.x - 17.5;
    [self.contentView layoutIfNeeded];
    if (_event) {
        _event(sender.tag);
    }
    _tempBtn = sender;
}



- (IBAction)payButtonDidClick:(UIButton *)sender {
    if (_event) {
        _event(sender.tag);
    }
}
@end
