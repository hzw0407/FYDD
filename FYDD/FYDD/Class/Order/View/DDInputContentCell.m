//
//  DDInputCell.m
//  FYDD
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDInputContentCell.h"

@implementation DDInputContentCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [_contentLb addTarget:self action:@selector(textChangeTarget) forControlEvents:UIControlEventEditingChanged];
}

- (void)textChangeTarget{
    if (_textChange) {
        _textChange(_contentLb.text, _indexPath);
    }
}

@end
