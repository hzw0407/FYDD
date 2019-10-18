//
//  DDOrderContactListCell.m
//  FYDD
//
//  Created by mac on 2019/4/27.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderContactListCell.h"

@implementation DDOrderContactListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)contactDidClick:(UIButton *)sender {
    if (_event)
        _event();
}


@end
