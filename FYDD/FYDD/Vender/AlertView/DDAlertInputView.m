//
//  DDAlertInputView.m
//  FYDD
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDAlertInputView.h"
#import "UIView+TYAlertView.h"
#import "DDAlertCancelDailiView.h"

@interface DDAlertInputView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textTd;
@property (weak, nonatomic) IBOutlet UIView *inputvIEW;

@property (nonatomic,copy)DDInputTextBlock event;
@property (nonatomic,copy)DDcommitButtonBlock event1;
@end

@implementation DDAlertInputView

- (void)awakeFromNib{
    [super awakeFromNib];
    _inputvIEW.layer.borderColor = UIColorHex(0xEFEFF6).CGColor;
    _inputvIEW.layer.borderWidth = 1;
    _inputvIEW.layer.cornerRadius = 3;
    _inputvIEW.clipsToBounds = YES;
    _textTd.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    if ([textField isEqual:_textTd]) {
        //不允许超过11位
        if (pointLength > 11) {
            return NO;
        }
        return YES;
    }
    return NO;
}


- (IBAction)buttonDidClick:(UIButton *)sender {
    if (sender.tag == 2) {
        if (_event1) _event1();
        [self hideView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            DDAlertCancelDailiView * topView = [[[NSBundle mainBundle] loadNibNamed:@"DDAlertCancelDailiView" owner:nil options:nil] lastObject];
            topView.bounds = [UIScreen mainScreen].bounds;
            [topView showInWindow];
        });
    }else {
        if (_textTd.text.length == 8 ||
            _textTd.text.length == 11) {
            if (_event) _event(_textTd.text);
             [self hideView];
        }else {
            if (_textTd.text.length == 0){
                [DDHub hubText:@"代理码不能为空,请输入代理码"];
                return;
            }
        }
    }
}

+ (void)showEvent:(DDInputTextBlock)event
      cancelEvent:(DDcommitButtonBlock)cancel{
    DDAlertInputView * alertView = [self alertView];
    alertView.event = event;
    alertView.event1 = cancel;
    [alertView showInWindow];
}

+ (DDAlertInputView * )alertView {
    DDAlertInputView * view = [DDAlertInputView createViewFromNib];
    view.width = kScreenSize.width - 30;
    return view;
}
@end
