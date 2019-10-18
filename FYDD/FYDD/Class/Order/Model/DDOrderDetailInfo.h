//
//  DDOrderDetailInfo.h
//  FYDD
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDOrderInfo.h"


@interface DDOrderDetailInfo : NSObject
@property (nonatomic,copy) NSString * extension;
@property (nonatomic,assign) double extensionScore;
@property (nonatomic,copy) NSString * implementation;
@property (nonatomic,assign) double implementationScore;
@property (nonatomic,copy) NSString * orderEvaluates;
@property (nonatomic,copy) NSString * onlineMemberName;
@property (nonatomic,strong) DDOrderInfo * orders;
@property (nonatomic,assign) NSInteger isShowInvoiceBtn;
@property (nonatomic,strong) NSDate * date;
@end


