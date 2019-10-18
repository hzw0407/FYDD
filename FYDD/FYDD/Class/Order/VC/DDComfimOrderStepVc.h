//
//  DDComfimOrderStepVc.h
//  FYDD
//
//  Created by wenyang on 2019/9/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOrderDetailObj.h"
#import "DDOrderPlanModel.h"

@interface DDComfimOrderStepVc : DDBaseVC
@property (nonatomic,strong) DDOrderDetailObj * order;
@property (nonatomic,strong) DDOrderPlanModel * planModel;
@end


