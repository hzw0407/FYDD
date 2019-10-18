//
//  DDOrderDownCell.m
//  FYDD
//
//  Created by mac on 2019/4/30.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderDownCell.h"

@implementation DDOrderDownCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonDidClick:(UIButton *)sender {
    if (_event) {
        _event(sender.tag);
    }
}

@end
