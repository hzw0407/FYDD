//
//  BWPlanDetailCell.h
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWPlanModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BWPlanDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyLb;
@property (weak, nonatomic) IBOutlet UILabel *orderLb;
@property (weak, nonatomic) IBOutlet UILabel *soialCodeLb;
@property (weak, nonatomic) IBOutlet UILabel *hanyLb;
@property (weak, nonatomic) IBOutlet UILabel *userNumberLb;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *versionLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb1;
@property (weak, nonatomic) IBOutlet UILabel *dateLb2;
@property (weak, nonatomic) IBOutlet UILabel *dateLb3;
@property (weak, nonatomic) IBOutlet UILabel *dateLb4;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (nonatomic,strong) BWPlanModel * planModel;
@property (weak, nonatomic) IBOutlet UILabel *shishiLb;
@property (weak, nonatomic) IBOutlet UILabel *contactNaneLb;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLb;
@property (weak, nonatomic) IBOutlet UILabel *CheckLabel;

@property (nonatomic,copy) void (^orderDidClick)(void);
@end

NS_ASSUME_NONNULL_END
