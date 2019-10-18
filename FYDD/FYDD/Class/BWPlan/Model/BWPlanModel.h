//
//  BWPlanModel.h
//  FYDD
//
//  Created by wenyang on 2019/9/2.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BWPlanModel : NSObject
@property (nonatomic,copy) NSString * customerName;
@property (nonatomic,copy) NSString * customerStatus;
@property (nonatomic,copy) NSString * orderNumber;
@property (nonatomic,copy) NSString * customerCreditCode;
@property (nonatomic,copy) NSString * categoriesName;
@property (nonatomic,copy) NSString * customerIndustry;
@property (nonatomic,copy) NSString * beginTime;
@property (nonatomic,copy) NSString * startTime;
@property (nonatomic,copy) NSString * deliverTime;
@property (nonatomic,copy) NSString * castTime;
@property (nonatomic,copy) NSString * paymentTime;
@property (nonatomic,copy) NSString * companyId;
@property (nonatomic,copy) NSString * planId;
@property (nonatomic,copy) NSString * contactsName;
@property (nonatomic,copy) NSString * contactsTelephone;
@property (nonatomic,assign) NSInteger companyNumber;
@property (nonatomic,assign) NSInteger planExpireDay;
@property (nonatomic,copy) NSString * legalUser;
@property (nonatomic,assign) double orderAccount;
@end


