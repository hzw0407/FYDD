//
//  DDBankModelHistoryModel.h
//  FYDD
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DDBankModelHistoryModel : NSObject
@property (assign, nonatomic) NSInteger moneyId;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *bankType;
@property (copy, nonatomic) NSString *amount;
@property (copy, nonatomic) NSString *createDate;
@property (copy, nonatomic) NSString *tradingAccount;
@property (copy, nonatomic) NSString *bankTime;
@property (copy, nonatomic) NSString *bankNo;
- (void)layout;
@end


