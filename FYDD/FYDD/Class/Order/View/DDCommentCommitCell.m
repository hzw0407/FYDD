//
//  DDCommentCommitCell.m
//  FYDD
//
//  Created by mac on 2019/4/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDCommentCommitCell.h"

@implementation DDCommentCommitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)commitBtnDidClick {
    if (_event){
        _event();
    }
}

@end
