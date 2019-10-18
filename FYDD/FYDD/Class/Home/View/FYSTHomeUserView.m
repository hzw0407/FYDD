//
//  FYSTHomeUserView.m
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "FYSTHomeUserView.h"

@implementation FYSTHomeUserView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)fystUserButtonDidClick {
    if (_fystMenuButtonDidClick){
        _fystMenuButtonDidClick(0);
    }
}

@end
