//
//  DDInputCell.m
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDInputCell.h"

@interface DDInputCell()<UITextFieldDelegate> {
    NSTimer * _timer;
    NSInteger _timerCount;
}

@end

@implementation DDInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _codeBtn.layer.borderWidth = 1;
    _codeBtn.clipsToBounds = YES;
    _codeBtn.layer.borderColor = [DDAppManager share].appTintColor.CGColor;
    [_textTd addTarget:self action:@selector(textChangeTarget) forControlEvents:UIControlEventEditingChanged];
    _textTd.delegate = self;
    
    _maxLimit = NSUIntegerMax;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    if ([textField isEqual:_textTd]) {
        //不允许超过11位
        if (pointLength > _maxLimit) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (void)textChangeTarget{
    if (_textChange) {
        _textChange(_textTd.text, _indexPath);
    }
}

- (IBAction)codeBtnDidClick:(id)sender {
    if (_codeBlock) {
        _codeBlock();
    }
}

// 开始计时
- (void)start{
    [self _startTimer];
}

// 结束
- (void)stop{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        _codeBtn.userInteractionEnabled = YES;
        _codeBtn.layer.borderColor = [DDAppManager share].appTintColor.CGColor;
        [_codeBtn setTitleColor:[DDAppManager share].appTintColor forState:UIControlStateNormal];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)_startTimer{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
    _codeBtn.layer.borderColor = UIColorHex(0xdddddd).CGColor;
    [_codeBtn setTitleColor:UIColorHex(0xdddddd) forState:UIControlStateNormal];
    _codeBtn.userInteractionEnabled = NO;
    _timerCount = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(_timerLoop) userInfo:nil repeats:YES];
}

- (void)_timerLoop{
    _timerCount -= 1;
    if (_timerCount == 0){
        [self stop];
        return;
    }
    [_codeBtn setTitle:[NSString stringWithFormat:@"%zd",_timerCount] forState:UIControlStateNormal];
}

@end
