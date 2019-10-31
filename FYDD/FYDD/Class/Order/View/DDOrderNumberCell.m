//
//  DDOrderNumberCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderNumberCell.h"

@interface DDOrderNumberCell () {
    NSTimer * _timer;
    NSInteger _timeIter;
}

@end

@implementation DDOrderNumberCell

- (IBAction)orderCopyButtonDidClick:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = _detailObj.orderNumber;
    [DDHub hubText:@"复制成功"];
}


- (void)setDetailObj:(DDOrderDetailObj *)detailObj{
    _detailObj = detailObj;
    _orderLb.text = detailObj.orderNumber;
    NSDateFormatter * formater = [NSDateFormatter new];
    formater.dateFormat = @"yyyy-MM-dd";
    
    if (detailObj.dispatchDate == 0) {
        //待接单
        _dispDateNameLb.text = @"版本价格";
        _nameLb2.text = @"实施费用";
        _nameLb3.text = @"合计价格";
        _nameLb4.text = @"使用期限";
        _dateLb.text = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:detailObj.createDate / 1000]];
        
        
        if ([detailObj.accountNumberPrice doubleValue] == 0) {
            _paidanLv.text = @"免费";
        }else {
            _paidanLv.text = [NSString stringWithFormat:@"¥%.f",[detailObj.accountNumberPrice doubleValue]];
        }
        
        
        if (detailObj.implementationCost == 0) {
            _priceLb.text = @"免费";
        }else {
            _priceLb.text = [NSString stringWithFormat:@"¥%.f",detailObj.implementationCost];
        }
        
        if (_detailObj.productUseTime == -1 || !_detailObj.isCompanyFirst){
            _totalPriceLb.text = @"永久";
        }else {
            _totalPriceLb.text = [NSString stringWithFormat:@"%zd天",detailObj.productUseTime];
        }
        
        
        if ([detailObj.accountNumberPrice doubleValue] + detailObj.implementationCost == 0){
            _feiyongLb.text = @"免费";
        }else {
            _feiyongLb.text = [NSString stringWithFormat:@"¥%.f",[detailObj.accountNumberPrice doubleValue] + detailObj.implementationCost];
        }
        
    }else {
        //已完成
        _dateLb.text = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:detailObj.createDate / 1000]];
        _paidanLv.text = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:detailObj.dispatchDate / 1000]];
        
        if ([detailObj.accountNumberPrice doubleValue] == 0) {
            _priceLb.text = @"免费";
        }else {
            _priceLb.text = [NSString stringWithFormat:@"¥%.f",[detailObj.accountNumberPrice doubleValue]];
        }
        
        
        if (detailObj.implementationCost == 0) {
            _feiyongLb.text = @"免费";
        }else {
            _feiyongLb.text = [NSString stringWithFormat:@"¥%.f",detailObj.implementationCost];
        }
        
//        if (_detailObj.productUseTime == -1 || !_detailObj.isCompanyFirst){
//            _shiyongLb.text = @"永久";
//        }else {
//            _shiyongLb.text = [NSString stringWithFormat:@"%zd天",detailObj.productUseTime];
//        }
        
        if ([detailObj.accountNumberPrice doubleValue] + detailObj.implementationCost == 0) {
            _totalPriceLb.text = @"免费";
        }else {
            _totalPriceLb.text = [NSString stringWithFormat:@"¥%.f",[detailObj.accountNumberPrice doubleValue] + detailObj.implementationCost];
        }
    }
    
   
    
    // 待接单
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if ((detailObj.orderStatusType == DDOrderStatusOrderTaking ||
        detailObj.orderStatusType == DDOrderStatusLeaflets) &&
        [DDUserManager share].user.userType != DDUserTypePromoter) {
        _remainDateLb.hidden = NO;
         _remainDateLb.text = @"00:00:00";
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:_detailObj.dispatchDate / 1000];
        _timeIter =  [date timeIntervalSinceNow] - [[NSDate date] timeIntervalSinceNow] + 72 * 60 * 60;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scheduledTinwe) userInfo:nil repeats:YES];
        [self scheduledTinwe];
    }else {
        _remainDateLb.hidden = YES;
    }
}

- (void)scheduledTinwe{
    _timeIter -= 1;
    if (_timeIter > 0) {
        NSInteger value1 = (_timeIter/3600)/10;
        NSInteger value2 = (_timeIter/3600)%10;
        NSInteger value3 = (_timeIter%3600)/600;
        NSInteger value4 = ((_timeIter/3600)/60)%10;
        NSInteger value5 = (_timeIter%60)/10;
        NSInteger value6 = (_timeIter%60)%10;
        if ([DDUserManager share].user.userType == DDUserTypeSystem) {
            _remainDateLb.text = [NSString stringWithFormat:@"实施方将在%zd%zd: %zd%zd: %zd%zd内接单",value1,value2,value3,value4,value5,value6];
        }else {
            _remainDateLb.text = [NSString stringWithFormat:@"请在%zd%zd: %zd%zd: %zd%zd内接单",value1,value2,value3,value4,value5,value6];
        }
    }else {
//        _remainDateLb.text = @"等待接单已经超时";
        _remainDateLb.text = @"";
    }
    
    
}

@end
