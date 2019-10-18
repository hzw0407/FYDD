//
//  DDOnlineModel.h
//  FYDD
//
//  Created by mac on 2019/4/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DDOnlineModel : NSObject
@property (nonatomic,assign) double commissionFee;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,copy) NSString * userPhone;
@property (nonatomic,copy) NSString * userCity;
@property (nonatomic,copy) NSString * onlineName;
@property (nonatomic,assign) NSInteger onlineId;
@property (nonatomic,assign) BOOL isSelected;
@end


