//
//  DDMoneyTopCell.m
//  FYDD
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDMoneyTopCell.h"

@implementation DDMoneyTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.btn.layer.borderColor = UIColorHex(0xC6CFD6).CGColor;
//    self.btn.layer.borderWidth = 1;
//    
//    self.startBtn.layer.borderColor = UIColorHex(0xC6CFD6).CGColor;
//    self.startBtn.layer.borderWidth = 1;
//    
//    self.endBtn.layer.borderColor = UIColorHex(0xC6CFD6).CGColor;
//    self.endBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnClick:(UIButton *)sender {
    if (_event) {
        _event(sender.tag);
    }
}

@end
