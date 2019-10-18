//
//  DDSenderImageCell.m
//  FYDD
//
//  Created by mac on 2019/4/15.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDSenderImageCell.h"

@implementation DDSenderImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonDidClick {
    if (_SenderImageBlock) {
        _SenderImageBlock(self);
    }
}

@end
