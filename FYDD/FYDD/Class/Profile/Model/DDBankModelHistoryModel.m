//
//  DDBankModelHistoryModel.m
//  FYDD
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDBankModelHistoryModel.h"

@implementation DDBankModelHistoryModel
- (void)layout{
    if ([_createDate rangeOfString:@"."].location != NSNotFound) {
        _bankTime = [[_createDate componentsSeparatedByString:@"."] firstObject];
        _bankTime = [_bankTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }else {
        _bankTime = _createDate;
    }
    if (_tradingAccount.length > 4) {
        _bankNo = [_tradingAccount substringFromIndex:_tradingAccount.length - 4] ;
    }else {
        _bankNo = _tradingAccount ;
    }
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"moneyId":@"walletRecordId"};
}
@end
