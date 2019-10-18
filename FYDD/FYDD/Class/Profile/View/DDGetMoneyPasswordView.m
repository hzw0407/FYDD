//
//  DDGetMoneyPasswordView.m
//  FYDD
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDGetMoneyPasswordView.h"
#import "TYAlertController.h"
@interface DDGetMoneyPasswordView(){
    TYAlertController *_alertController;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;

@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *paswordKeys;
@property (nonatomic,copy) DDInputTextBlock text;
@end

@implementation DDGetMoneyPasswordView

- (void)showFrom:(UIViewController *)from
      completion:(DDInputTextBlock)completion{
    _titleLB.text = _title;
    _moneyLb.text = [NSString stringWithFormat:@"¥%.2f",_money];
    _alertController = [TYAlertController alertControllerWithAlertView:self preferredStyle:TYAlertControllerStyleActionSheet];
    _alertController.backgoundTapDismissEnable = YES;
    [_textView becomeFirstResponder];
    _text = completion;
    [from presentViewController:_alertController animated:YES completion:nil];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChangeOneCI:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:_textView];
}

- (void)textFieldTextDidChangeOneCI:(NSNotification *)notification{
    NSInteger count = _textView.text.length;
    for (NSInteger i =0; i<_paswordKeys.count;i++){
        UIView * view = _paswordKeys[i];
        if (i < count) {
            view.hidden = NO;
        }else {
            view.hidden = YES;
        }
    }
    
    if (_textView.text.length == 6) {
        if (_text){
            _text(_textView.text);
        }
        @weakify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self)
            [self->_textView endEditing:YES];
            [self->_alertController dismissViewControllerAnimated:YES];
        });
    }
}

- (IBAction)closeBtnDidClick {
    [_alertController dismissViewControllerAnimated:YES];
}

@end
