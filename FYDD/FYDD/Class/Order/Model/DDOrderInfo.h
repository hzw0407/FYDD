//
//  DDOrderInfo.h
//  FYDD
//
//  Created by mac on 2019/4/1.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DDOrderInfo : NSObject
@property (nonatomic,copy) NSString * apply2no;
@property (nonatomic,copy) NSString * applyno;

@property (nonatomic,copy) NSString * orderId;
@property (nonatomic,copy) NSString * createDate;
@property (nonatomic,copy) NSString * enterpriseName;
@property (nonatomic,assign)NSInteger extensionMember;
@property (nonatomic,copy) NSString* extensionName;
@property (nonatomic,copy) NSString * extensionPhone;
@property (nonatomic,assign) double implementationCost;
@property (nonatomic,assign) NSString * implementationMember;
@property (nonatomic,copy) NSString * implementationName;
@property (nonatomic,copy) NSString * implementationPhone;
@property (nonatomic,copy) NSString * implementationStatus;
@property (nonatomic,assign) BOOL isInvoice;
@property (nonatomic,assign) BOOL isRenew;
@property (nonatomic,copy) NSString * nextBalanceDate;
@property (nonatomic,copy) NSString * oldOrderNumber;
@property (nonatomic,copy) NSString * onlineUserId;
@property (nonatomic,copy) NSString * orderArea;
@property (nonatomic,copy) NSString * orderNumber;
@property (nonatomic,copy) NSString * orderStatus;
@property (nonatomic,assign) NSInteger packageId;
@property (nonatomic,assign) double paymentAmount;
@property (nonatomic,assign) NSInteger paymentStatus;
@property (nonatomic,copy) NSString * paymentType;
@property (nonatomic,assign) double productAmount;
@property (nonatomic,assign) NSInteger productId;
@property (nonatomic,assign) BOOL isCompanyFirst;
@property (nonatomic,copy) NSString * productName;
@property (nonatomic,assign) NSInteger productUseTime;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,copy) NSString * userLinkman;
@property (nonatomic,copy) NSString * userLinkmanPhone;
@property (nonatomic,copy) NSString * orderStatusMessage;
@property (nonatomic,copy) NSString * orderDate;
@property (nonatomic,copy) NSString * dispatchDate;
@property (nonatomic,copy) NSString * serviceDate;
@property (nonatomic,copy) NSString * deploymentStartDate;
@property (nonatomic,copy) NSString * deploymentEndDate;
@property (nonatomic,copy) NSString * dueDate;
@end

// 实施方案
@interface DDOrderCheckUser : NSObject
@property (nonatomic,copy) NSString * onlineName; // 等级
@property (nonatomic,copy) NSString * upgradeRatio; // 升级0.01
@property (nonatomic,copy) NSString * totlaScore; // 服务评价
@property (nonatomic,copy) NSString * orderTotalAmount; // 累计收入
@property (nonatomic,copy) NSString * settlementMoney; // 结算收入
@property (nonatomic,copy) NSString * totalIncome;
@end


// 代理方
@interface DDOrderExtensionUser : NSObject
@property (nonatomic,copy) NSString * extensionName; // 等级
@property (nonatomic,copy) NSString * upgradeRatio; // 升级0.01
@property (nonatomic,copy) NSString * totalScore; // 服务评价
@property (nonatomic,copy) NSString * orderTotalAmount; // 累计收入
@property (nonatomic,copy) NSString * settlementMoney; // 结算收入
@property (nonatomic,copy) NSString * totalIncome;
@end
