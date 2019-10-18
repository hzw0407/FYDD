//
//  DDIDCardView.m
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDIDCardView.h"
#import "UIView+TYAlertView.h"
#import <UIButton+WebCache.h>

@interface DDIDCardView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons;

@end

@implementation DDIDCardView


- (IBAction)buttonDidClick:(UIButton *)sender {
    if (_event) {
        _event(sender.tag);
        [self hideInController];
    }
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    if (iPhoneXAfter) {
        _cons.constant = 20 ;
    }
    _iconView1.imageView.contentMode = UIViewContentModeScaleToFill;
    _iconView2.imageView.contentMode = UIViewContentModeScaleToFill;
}


- (void)setIconImage1:(NSString  *)url{
    _iconLb1.hidden = url != nil;
    if (url){
        [_iconView1 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
    }else {
        [_iconView1 setImage:[UIImage imageNamed:@"icon_add_t"] forState:UIControlStateNormal];
    }
}

- (void)setIconImage2:(NSString  *)url{
    _iconLb2.hidden = url != nil;
    if (url){
        [_iconView2 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
    }else {
        [_iconView2 setImage:[UIImage imageNamed:@"icon_add_t"] forState:UIControlStateNormal];
    }
}

@end
