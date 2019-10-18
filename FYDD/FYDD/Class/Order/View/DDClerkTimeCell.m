//
//  DDClerkTimeCell.m
//  FYDD
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDClerkTimeCell.h"

@interface DDClerkTimeCell() {
    NSTimer * _timer;
    NSInteger _timeIter;
}

@end

@implementation DDClerkTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setDate:(NSDate *)date{
    _date = date;
    if (!_date) {
        _dateLb.text = @"00:00:00";
        return;
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timeIter =  [date timeIntervalSinceNow] - [[NSDate date] timeIntervalSinceNow] + 72 * 60 * 60;
    [self timeScheduled];
    if (_timeIter > 0) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeScheduled) userInfo:nil repeats:YES];
    }else {
        _dateLb.text = @"等待接单已经超时";
    }
}

- (void)timeScheduled{
    _timeIter -= 1;
     NSInteger value1 = (_timeIter/3600)/10;
     NSInteger value2 = (_timeIter/3600)%10;
     NSInteger value3 = (_timeIter%3600)/600;
     NSInteger value4 = ((_timeIter/3600)/60)%10;
     NSInteger value5 = (_timeIter%60)/10;
     NSInteger value6 = (_timeIter%60)%10;
    if ([DDUserManager share].user.userType == DDUserTypeSystem) {
        _dateLb.text = [NSString stringWithFormat:@"实施方将在%zd%zd: %zd%zd: %zd%zd内接单",value1,value2,value3,value4,value5,value6];
    }else {
       _dateLb.text = [NSString stringWithFormat:@"请在%zd%zd: %zd%zd: %zd%zd内接单",value1,value2,value3,value4,value5,value6];
    }
    
}

@end
