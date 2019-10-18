//
//  DDOrderStepMenuView.m
//  FYDD
//
//  Created by wenyang on 2019/9/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderStepMenuView.h"
#import "UIView+TYAlertView.h"

@interface DDOrderStepMenuView ()
@property (nonatomic,copy) void (^callBlock)(BOOL isAgree);
@end

@implementation DDOrderStepMenuView

- (void)awakeFromNib{
    [super awakeFromNib];
    _button1.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _button1.layer.shadowOffset = CGSizeMake(0,3);
    _button1.layer.shadowRadius = 6;
    _button1.layer.shadowOpacity = 1;
    _button1.layer.cornerRadius = 20;
    
    _button2.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _button2.layer.shadowOffset = CGSizeMake(0,3);
    _button2.layer.shadowRadius = 6;
    _button2.layer.shadowOpacity = 1;
    _button2.layer.cornerRadius = 20;
}

- (IBAction)buttonDidClick:(UIButton *)sender {
    if (_callBlock) {
        _callBlock(sender.tag == 0);
    }
    [self hideInWindow];
}

+ (void)show:(void (^)(BOOL))action{
   DDOrderStepMenuView * menView =  [DDOrderStepMenuView createViewFromNib];
   menView.callBlock = action;
    menView.size = CGSizeMake(kScreenSize.width, kScreenSize.height);
   [menView showInWindow];
}

- (IBAction)dismissView:(id)sender {
    [self hideInWindow];
}
@end
