//
//  DDMessageDetailVc.m
//  FYDD
//
//  Created by mac on 2019/4/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDMessageDetailVc.h"
#import <YYKit/YYKit.h>
@interface DDMessageDetailVc ()
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consHeight;

@end

@implementation DDMessageDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    _consHeight.constant = [yyTrimNullText(_messageText) sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(kScreenSize.width - 64, 100000) mode:NSLineBreakByWordWrapping].height + 40;
    _messageTextView.text = _messageText;
}


@end
