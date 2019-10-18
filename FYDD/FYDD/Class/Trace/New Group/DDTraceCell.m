//
//  DDTraceCell.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDTraceCell.h"
#import <SDWebImage/SDWebImage.h>
#import <FSCalendar/FSCalendar.h>

@implementation DDTraceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFootObj:(DDFootstripObj *)footObj{
    _footObj = footObj;
    _contentLb.text = footObj.title;
    _userNameLb.text = footObj.createUserName;
    if (yyTrimNullText(footObj.createUserLogo).length > 0) {
        [_iconLb sd_setImageWithURL:[NSURL URLWithString:footObj.createUserLogo]];
    }else {
        _iconLb.image = [UIImage imageNamed:[[DDUserManager share] userPlaceImage]];
    }
    NSDateFormatter * formater = [NSDateFormatter new];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDateFormatter * formater1 = [NSDateFormatter new];
    formater1.dateFormat = @"yyyy-MM-dd";
    NSDate * date = [formater dateFromString:footObj.updateTime];
    NSInteger number = [[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970];
    if (number < 3600) {
        _timeLb.text = @"一小时内";
    }else if (number / 3600 < 24) {
        _timeLb.text = [NSString stringWithFormat:@"%zd小时前",number / 3600 ];
    }else  {
        _timeLb.text = [formater1 stringFromDate:date];
    }
    NSArray * images = [_footObj.showImage componentsSeparatedByString:@"|"];
    if (images.count > 0) {
        [_traceImageView sd_setImageWithURL:[NSURL URLWithString:images[0]]];
    }
    
}


@end
