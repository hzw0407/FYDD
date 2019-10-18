//
//  DDOrderDetailObj.h
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DDOrderDetailObj : NSObject
@property (nonatomic,copy) NSString * accountNumberPrice;
@property (nonatomic,copy) NSString * categoryName;
@property (nonatomic,assign) NSInteger createDate;
@property (nonatomic,assign) double paymentAmount;
@property (nonatomic,assign) NSInteger dispatchDate;
@property (nonatomic,copy) NSString * extensionName;
@property (nonatomic,copy) NSString * extensionMember;
@property (nonatomic,copy) NSString * extensionPhone;
@property (nonatomic,assign) double extensionScore;

@property (nonatomic,copy) NSString * implementPlanDetailSeq;
@property (nonatomic,copy) NSString * implementPlanId;
@property (nonatomic,copy) NSString * implementName;
@property (nonatomic,assign) double implementationCost;
@property (nonatomic,assign) NSInteger isCompanyFirst;
@property (nonatomic,assign) NSInteger isInvoice;
@property (nonatomic,assign) NSInteger isShowInvoiceBtn;
@property (nonatomic,copy) NSString * onlineName;
@property (nonatomic,copy) NSString * onlinePhone;
@property (nonatomic,assign) double onlineScore;
@property (nonatomic,assign) NSInteger onlineTime;
@property (nonatomic,assign) NSInteger onlineUserId;
@property (nonatomic,copy) NSString * orderArea;
@property (nonatomic,copy) NSString * orderId;
@property (nonatomic,copy) NSString * orderNumber;
@property (nonatomic,copy) NSString * orderStatus;
@property (nonatomic,assign) DDOrderStatus orderStatusType;
@property (nonatomic,copy) NSString * productId;
@property (nonatomic,copy) NSString * productName;
@property (nonatomic,assign) NSInteger productUseTime;
@property (nonatomic,copy) NSString * userLinkman;
@property (nonatomic,copy) NSString * userLinkmanPhone;
@property (nonatomic,assign) NSInteger userNumber;
@end


