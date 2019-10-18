//
//  DDOrderTranferCell.m
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderTranferCell.h"
#import <UIButton+WebCache.h>

@implementation DDOrderTranferCell

- (void)awakeFromNib{
    [super awakeFromNib];
    _camaraBtn.layer.borderWidth = 1;
    _camaraBtn.layer.borderColor = UIColorHex(0xC6CFD6).CGColor;
    _camaraBtn.layer.cornerRadius = 2;
    _camaraBtn.layer.masksToBounds = YES;
    
    [_liushuimaLb addTarget:self action:@selector(textChangeTarget) forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)camaraButtonDidClick {
    if (_block) {
        _block(0);
    }
}

- (void)textChangeTarget{
    if (_textBlock){
        _textBlock(_liushuimaLb.text);
    }
}

- (void)setImageURL:(NSString *)url{
    if (!url) {
        _camaraBtn.layer.borderWidth = 1;
        _camaraBtn.layer.borderColor = UIColorHex(0xC6CFD6).CGColor;
        _camaraBtn.layer.cornerRadius = 2;
        _camaraBtn.layer.masksToBounds = YES;
        [_camaraBtn setImage:[UIImage imageNamed:@"icon_camra"] forState:UIControlStateNormal];
    }else {
        // icon_camra
        _camaraBtn.layer.borderWidth = 0;
        [_camaraBtn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];

    }
}
- (IBAction)phoneButtonDidClick:(UIButton *)sender {
    if (_phoneCallButtonDidClick) {
        _phoneCallButtonDidClick();
    }
}
@end
