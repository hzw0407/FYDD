//
//  DDOrderCompanyCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderCompanyCell.h"

@implementation DDOrderCompanyCell

- (IBAction)contactButtonDidClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_detailObj.userLinkmanPhone]]];
}

- (void)setDetailObj:(DDOrderDetailObj *)detailObj{
    _detailObj = detailObj;
    _contactNameLb.text = detailObj.userLinkman;
    [_contactPhoneButton setTitle:_detailObj.userLinkmanPhone forState:UIControlStateNormal];
    _contactAddtessLb.text = _detailObj.orderArea;
}

@end
