//
//  DDWalletModel.h
//  FYDD
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDWalletModel : NSObject
@property (assign, nonatomic) double amount;
@property (assign, nonatomic) double balance;
@property (copy, nonatomic) NSString *createDate;
@property (assign, nonatomic) NSInteger walletId;
@property (copy, nonatomic) NSString *rechargeType;
@property (assign, nonatomic) NSInteger serialNo;
@property (copy, nonatomic) NSString *source;
@property (copy, nonatomic) NSString *status;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger userId;
@property (copy, nonatomic) NSString *typeName;
@property (copy, nonatomic) NSString *typeFlag;
@end


