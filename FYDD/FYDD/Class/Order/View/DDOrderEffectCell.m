//
//  DDOrderEffectCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderEffectCell.h"

@implementation DDOrderEffectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)contactButtonDidCilck:(UIButton *)sender {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_detailObj.onlinePhone]]];
}

- (void)setDetailObj:(DDOrderDetailObj *)detailObj{
    _detailObj = detailObj;
    _contactNameLb.text = _detailObj.onlineName;
    [_contactPhoneLb setTitle:_detailObj.onlinePhone forState:UIControlStateNormal];
    NSDateFormatter * formater = [NSDateFormatter new];
    formater.dateFormat = @"yyyy年MM月dd日";
    _contactTimeLb.text = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:detailObj.onlineTime/1000]];
    if (detailObj.onlineTime == 0) {
        _contactTimeLb.text = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:detailObj.createDate / 1000]];
    }
    self.ratingView.type = 1;
    self.ratingView.progress = _detailObj.onlineScore;
    self.ratingView.userInteractionEnabled = false;
    _scoreLb.text = [NSString stringWithFormat:@"%.1f",_detailObj.onlineScore];
}
@end
