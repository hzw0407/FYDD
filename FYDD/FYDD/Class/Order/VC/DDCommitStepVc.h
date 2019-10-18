//
//  DDCommitStepVc.h
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOrderDetailObj.h"
#import "DDOrderPlanModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDCommitStepVc : DDBaseVC
@property (nonatomic,strong) DDOrderDetailObj * order;
@property (nonatomic,strong) DDOrderPlanModel * planModel;
@end

NS_ASSUME_NONNULL_END
