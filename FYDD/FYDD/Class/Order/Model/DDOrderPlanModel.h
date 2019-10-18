//
//  DDOrderPlanModel.h
//  FYDD
//
//  Created by wenyang on 2019/9/6.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 195

@interface DDOrderPlanModel : NSObject
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSString * statusName;
@property (nonatomic,copy) NSString * evaluate1;
@property (nonatomic,copy) NSString * evaluate2;
@property (nonatomic,copy) NSString * evaluate3;
@property (nonatomic,copy) NSString * orderEvaluate1;
@property (nonatomic,copy) NSString * orderEvaluate2;
@property (nonatomic,copy) NSString * orderEvaluate3;
@property (nonatomic,copy) NSString * onlineContent;
@property (nonatomic,copy) NSString * onlineRemarks;
@property (nonatomic,copy) NSString * planDetailId;
@property (nonatomic,strong) NSArray * imgs;
@property (nonatomic,copy) NSString * planId;
@property (nonatomic,copy) NSString * modelId;
@property (nonatomic,copy) NSString * orderDetailId;
@property (nonatomic,copy) NSString * planName;
@property (nonatomic,assign) NSInteger step;
@property (nonatomic,copy) NSString * detailTitle;
@property (nonatomic,copy) NSString * detail;
@property (nonatomic,copy) NSString * userDetail;

@property (nonatomic,assign) double imagesHeight;
@property (nonatomic,assign) double ideaHeight;
@property (nonatomic,assign) double ideaHeight1;
@property (nonatomic,assign) double cellHeight;
@property (nonatomic,assign) double imageWidth;

- (void)layoutCons;

- (NSString *)convertEvaluate:(NSString *)eval;
@end

NS_ASSUME_NONNULL_END
