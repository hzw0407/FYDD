//
//  DDProductItemView.m
//  FYDD
//
//  Created by wenyang on 2019/9/7.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProductItemView.h"

@implementation DDProductItemView


- (IBAction)productButtonDidClick:(UIButton *)sender {
    if (_itemBlock) {
        _itemBlock(self.tag);
    }
}
@end
