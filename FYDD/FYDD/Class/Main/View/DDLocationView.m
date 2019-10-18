//
//  DDLocationView.m
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDLocationView.h"

@implementation DDLocationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)buttonDidClick {
    if (_event) {
        _event();
    }
    
}

- (CGSize)intrinsicContentSize{
    return UILayoutFittingExpandedSize;
    
}

@end
