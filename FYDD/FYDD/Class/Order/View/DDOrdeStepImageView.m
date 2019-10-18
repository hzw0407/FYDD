//
//  DDOrdeStepImageView.m
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrdeStepImageView.h"

@implementation DDOrdeStepImageView

- (IBAction)closeButtonDidClick:(UIButton *)sender {
    if (_stepOrderButtonDidClick) {
        _stepOrderButtonDidClick(sender.tag);
    }
}

- (IBAction)composeButtonDidClick:(UIButton *)sender {
    if (_stepOrderButtonDidClick) {
        _stepOrderButtonDidClick(sender.tag);
    }
}



@end
