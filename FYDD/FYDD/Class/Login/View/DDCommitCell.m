//
//  DDCommitCell.m
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDCommitCell.h"

@implementation DDCommitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _commitBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _commitBtn.layer.shadowOffset = CGSizeMake(0,3);
    _commitBtn.layer.shadowRadius = 6;
    _commitBtn.layer.shadowOpacity = 1;
    _commitBtn.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonDidClick {
    if (_event) {
        _event();
    }
}

@end
