//
//  DDAlertSheetView.m
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDAlertSheetView.h"

#import "UIView+TYAlertView.h"

@interface DDAlertSheetView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons;


@end

@implementation DDAlertSheetView


- (void)awakeFromNib{
    [super awakeFromNib];
    if (iPhoneXAfter) {
        _cons.constant = 20 ;
    }
}


- (IBAction)eventButtonDidClick {
    if (_event && _textLb.text.length > 0) {
        _event(_textLb.text);
        [self hideInController];
    }
}
@end
