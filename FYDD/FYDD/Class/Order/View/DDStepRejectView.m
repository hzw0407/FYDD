//
//  DDStepRejectView.m
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDStepRejectView.h"
#import "UIView+TYAlertView.h"

@implementation DDStepRejectView

- (void)awakeFromNib{
    [super awakeFromNib];
    _tempButton = _firtButton;
}

- (IBAction)buttonDidClick:(UIButton *)sender {
    if (_tempButton == sender) {
        return;
    }
    sender.selected = YES;
    _tempButton.selected = NO;
    _tempButton = sender;
    NSArray * dataList = @[@"1. 没有达到预期的效果",
                           @"2. 效率太慢！",
                           @"3. 沟通不到位，具体事宜没讲清楚",
                           @"4. 服务态度恶略",
                           @"5. 双方协商，确认换人",
                           @"6. 其他原因"];
    
    _currentIndex = sender.tag;
    
    _textTd.text = dataList[sender.tag];
}

- (IBAction)cancelButtonDidClick:(UIButton *)sender {
    [self hideView];
}

- (IBAction)comfirmButtonClick:(UIButton *)sender {
    [self hideView];
    if (_rejectButtonDidClick) {
        _rejectButtonDidClick(_textTd.text);
    }
}

+ (void)show:(void (^)(NSString * message))rejectCompeltion vc:(UIViewController *)vc{
    DDStepRejectView * stepView  = [self createViewFromNib];
    stepView.width = kScreenSize.width;
    stepView.height = kScreenSize.height;
    stepView.rejectButtonDidClick = rejectCompeltion;
    [stepView showInController:vc];
}
@end
