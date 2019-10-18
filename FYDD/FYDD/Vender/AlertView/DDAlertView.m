//
//  DDAlertView.m
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDAlertView.h"
#import "UIView+TYAlertView.h"
#import <NSString+YYAdd.h>
@interface DDAlertView ()
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;

@property (nonatomic,copy)DDcommitButtonBlock event;
@property (nonatomic,copy)DDcommitButtonBlock event1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons1;
@end

@implementation DDAlertView
- (IBAction)buttonDidClick:(UIButton *)sender {
    if (sender.tag == 2) {
        if (_event) _event();
    }else {
        if (_event1) _event1();
    }
    [self hideView];
}


+ (void)showTitle:(NSString *)title subTitle:(NSString *)subTitle cancelEvent:(DDcommitButtonBlock)event{
    DDAlertView * alertView = [self alertView];
    alertView.cons1.constant = kScreenSize.width - 60;
    alertView.event = event;
    alertView.button2.hidden = true;
    alertView.titleLb.text = title;
    alertView.subTitleLb.text = subTitle;
    [alertView showInWindow];
}

+ (void)showTitle:(NSString *)title
         subTitle:(NSString *)subTitle
        sureEvent:(DDcommitButtonBlock)event
      cancelEvent:(DDcommitButtonBlock)event1{
    DDAlertView * alertView = [self alertView];
    alertView.cons1.constant = (kScreenSize.width - 60) * 0.5;
    alertView.cons2.constant = (kScreenSize.width - 60) * 0.5;
    alertView.event = event;
    alertView.event1 = event1;
    alertView.titleLb.text = title;
    alertView.subTitleLb.text = subTitle;
    [alertView showInWindow];
}

+ (void)showTitle:(NSString *)title
         subTitle:(NSString *)subTitle
        sureEvent:(DDcommitButtonBlock)event
      cancelEvent:(DDcommitButtonBlock)event1
         autoSize:(BOOL)isAuto{
    DDAlertView * alertView = [self alertView];
    alertView.cons1.constant = (kScreenSize.width - 60) * 0.5;
    alertView.cons2.constant = (kScreenSize.width - 60) * 0.5;
    alertView.event = event;
    alertView.event1 = event1;
    alertView.titleLb.text = title;
    alertView.subTitleLb.text = subTitle;
    alertView.subTitleLb.textAlignment = NSTextAlignmentCenter;
    CGFloat height = [subTitle sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(kScreenSize.width - 100, 100000) mode:NSLineBreakByWordWrapping].height;
    alertView.height = height + 130;
    [alertView showInWindow];
}

+ (void)showTitle:(NSString *)title
         subTitle:(NSString *)subTitle
      actionName1:(NSString *)name1
      actionName2:(NSString *)name2
        sureEvent:(DDcommitButtonBlock)event
      cancelEvent:(DDcommitButtonBlock)event1{
    DDAlertView * alertView = [self alertView];
    alertView.cons1.constant = (kScreenSize.width - 60) * 0.5;
    alertView.cons2.constant = (kScreenSize.width - 60) * 0.5;
    alertView.event = event;
    alertView.event1 = event1;
    alertView.titleLb.text = title;
    alertView.subTitleLb.text = subTitle;
    [alertView.button1 setTitle:name1 forState:UIControlStateNormal];
    [alertView.button2 setTitle:name2 forState:UIControlStateNormal];
    [alertView showInWindow];
}

+ (DDAlertView * )alertView {
    DDAlertView * view = [DDAlertView createViewFromNib];
    view.width = kScreenSize.width - 60;
    return view;
}

@end
