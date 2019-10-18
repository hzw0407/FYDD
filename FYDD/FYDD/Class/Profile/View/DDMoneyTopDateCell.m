//
//  DDMoneyTopDateCell.m
//  FYDD
//
//  Created by mac on 2019/5/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDMoneyTopDateCell.h"

@implementation DDMoneyTopDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btn.layer.borderColor = UIColorHex(0xC6CFD6).CGColor;
    self.btn.layer.borderWidth = 1;
    

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
