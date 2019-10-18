//
//  DDProductObj.h
//  FYDD
//
//  Created by wenyang on 2019/9/7.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DDOnlineModel.h"

@interface DDProductPort : NSObject
@property (nonatomic,copy) NSString * portId;
@property (nonatomic,assign) double marketPrice;
@property (nonatomic,assign) double afterImplementPrice;
@property (nonatomic,assign) double salePrice;
@property (nonatomic,assign) double afterMarketPrice;
@property (nonatomic,assign) double implementPrice;
@property (nonatomic,assign) double discount;
@property (nonatomic,copy) NSString * packageTitle;

@end

@interface DDProductObj : NSObject
@property (nonatomic,copy) NSString * backImg;
@property (nonatomic,copy) NSString * productName;
@property (nonatomic,assign) NSInteger objId;
@property (nonatomic,copy) NSString * productDetails;
@property (nonatomic,copy) NSString * productSharePath;
@property (nonatomic,assign) double salePrice;
@property (nonatomic,assign) double discount;
@end

@interface DDProductDetailObj : DDProductObj
@property (nonatomic,assign) NSInteger testUseTime;
@property (nonatomic,copy) NSString * shareTitle;
@property (nonatomic,copy) NSString * shareContext;
@property (nonatomic,copy) NSString * shareImage;
@property (nonatomic,strong) NSArray * list;
//
@property (nonatomic,copy) NSString * extensionUserName;
@property (nonatomic,copy) NSString * extensionName;
@property (nonatomic,copy) NSString * extensionPhone;
// 选择的端口
@property (nonatomic,strong) DDProductPort * port;
// 用户
@property (nonatomic,assign) BOOL isSystemOnline;
//
@property (nonatomic,strong) DDOnlineModel * onlineModel;
@end
