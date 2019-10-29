//
//  BWPlanCell.h
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWPlanModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BWPlanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyLb;
@property (weak, nonatomic) IBOutlet UILabel *orderLb;
@property (weak, nonatomic) IBOutlet UILabel *scoialLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb1;
@property (weak, nonatomic) IBOutlet UILabel *dateLb2;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong) BWPlanModel * planModel;
@property (weak, nonatomic) IBOutlet UILabel *BanBenlabel;
@property (weak, nonatomic) IBOutlet UILabel *HangYeLabel;

@property (weak, nonatomic) IBOutlet UILabel *dayLb;
@end

NS_ASSUME_NONNULL_END
