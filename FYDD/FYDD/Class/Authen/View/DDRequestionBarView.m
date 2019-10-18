//
//  DDRequestionBarView.m
//  FYDD
//
//  Created by wenyang on 2019/9/3.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDRequestionBarView.h"

@implementation DDRequestionBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)requestButtonDidClick:(UIButton *)sender {
    if(_bottomBarDidClick) {
        _bottomBarDidClick(sender.tag);
    }
}

@end
