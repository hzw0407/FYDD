//
//  FYSTNoticeCell.m
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "FYSTNoticeCell.h"
#import <YYKit/YYKit.h>
@implementation FYSTNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _productContainerView.pagingEnabled = YES;
}
- (IBAction)moduleDidClick:(UIButton *)sender {
    if (_moduleBlock) {
        _moduleBlock(sender.tag);
    }
}

- (void)setProductObjs:(NSArray *)productObjs{
    _productObjs = productObjs;
    [_productContainerView removeAllSubviews];
    if (productObjs.count == 0) return;
    CGFloat width = kScreenSize.width / 4;    
    for (NSInteger i =0; i < _productObjs.count; i++) {
        DDProductObj * obj = _productObjs[i];
        DDProductItemView * item = [[[NSBundle mainBundle] loadNibNamed:@"DDProductItemView" owner:nil options:nil] lastObject];
        item.frame = CGRectMake(i* width, 0, width, 100);
        item.nameLb.text = obj.productName;
        if (obj.backImg) [item.iconView sd_setImageWithURL:[NSURL URLWithString:obj.backImg]];
        item.tag = i;
        item.itemBlock = _itemBlock;
        [_productContainerView addSubview:item];
    }
    _productContainerView.contentSize = CGSizeMake(width * _productObjs.count, 0);
}


- (void)setMessages:(NSArray *)messages{
    _messages = messages;
    _messageContentView.scrollEnabled = NO;
    [_messageContentView removeAllSubviews];
    CGFloat left = 0;
    for (NSInteger i =0; i < messages.count; i++) {
        DDMessageModel * obj = messages[i];
        UIButton * messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageButton setTitle:obj.messageContent forState:UIControlStateNormal];
        messageButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [messageButton setTitleColor:UIColorHex(0x131313) forState:UIControlStateNormal];
        CGFloat width = [obj.messageContent sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(10000, 44) mode:NSLineBreakByWordWrapping].width + 40;
        messageButton.frame = CGRectMake(left, 0, width, 44);
        left += width;
        [_messageContentView addSubview:messageButton];
        messageButton.tag = i;
        [messageButton addTarget:self action:@selector(messageDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    _placeLb.hidden = _messages.count != 0;
    
    _contentWidth = left + kScreenSize.width - 64;
    _messageContentView.contentSize = CGSizeMake(_contentWidth, 0);
    if (_contentWidth > kScreenSize.width - 65) {
        _contentLeft = 0;
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scheduled) userInfo:nil repeats:YES];
    }
}

- (void)scheduled{
    _contentLeft += 0.5;
    [_messageContentView setContentOffset:CGPointMake(_contentLeft, 0)];
    if (_contentLeft > _contentWidth - kScreenSize.width  * 0.7) {
        _contentLeft = 0;
    }
}

- (void)messageDidClick:(UIButton *)btn{
    if (_messageBlock) {
        _messageBlock(btn.tag);
    }
}
@end
