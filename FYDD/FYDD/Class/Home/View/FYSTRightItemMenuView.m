//
//  FYSTRightItemMenuView.m
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "FYSTRightItemMenuView.h"

@implementation FYSTRightItemMenuView

- (IBAction)commetButtonDidClick {
    if (_fystMenuButtonDidClick){
        _fystMenuButtonDidClick(1);
    }
}



@end
