//
//  DDBaseCell.m
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDBaseCell.h"

@implementation DDBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)switchOn:(UISwitch *)sender {
    if (_event) {
        _event(sender.on ? 1 : 0);
    }
}

@end
