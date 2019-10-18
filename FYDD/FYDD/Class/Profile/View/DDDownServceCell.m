//
//  DDDownServceCell.m
//  FYDD
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDDownServceCell.h"

@implementation DDDownServceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _btn.layer.cornerRadius = 3;
    _btn.layer.borderWidth = 1;
    _btn.layer.borderColor = UIColorHex(0xf5f5f5).CGColor;
}


- (IBAction)btnDidClick {
    if (_event){
        _event(0);
    }
}

@end
