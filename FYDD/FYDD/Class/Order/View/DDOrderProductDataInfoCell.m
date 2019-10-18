//
//  DDOrderProductInfoCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderProductDataInfoCell.h"

@implementation DDOrderProductDataInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)contanctButtonDidClick:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_detailObj.extensionPhone]]];
}

- (void)setDetailObj:(DDOrderDetailObj *)detailObj{
    _detailObj = detailObj;
    _productNamelB.text = detailObj.productName;
    self.startRatingView.type = 1;
    self.startRatingView.progress = _detailObj.extensionScore;
    self.startRatingView.userInteractionEnabled = false;
    _productCountLb.text = [NSString stringWithFormat:@"%zd",_detailObj.userNumber];
    _shouliLb.text = _detailObj.extensionName;
    _scoreLb.text = [NSString stringWithFormat:@"%.1f",detailObj.extensionScore];
    [_contactButton setTitle:_detailObj.extensionPhone forState:UIControlStateNormal];
}

@end
