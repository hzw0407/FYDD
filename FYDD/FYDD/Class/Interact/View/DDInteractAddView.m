//
//  DDInteractAddView.m
//  FYDD
//
//  Created by wenyang on 2019/9/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDInteractAddView.h"

@implementation DDInteractAddView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)buttonDidClick:(UIButton *)sender {
    if (_interactBlock) {
        _interactBlock(sender.tag);
    }
}

@end
