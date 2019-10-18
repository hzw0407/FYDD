//
//  DDChangeCarryUserVcViewController.h
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOrderDetailObj.h"
#import "DDOrderPlanModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDChangeCarryUserVcViewController : UIViewController
@property (nonatomic,strong) DDOrderDetailObj * order;
@property (nonatomic,strong) NSArray * plans;
@end

NS_ASSUME_NONNULL_END
