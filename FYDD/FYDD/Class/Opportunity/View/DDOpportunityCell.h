//
//  DDOpportunityCell.h
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOpportunityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDOpportunityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyLb;
@property (weak, nonatomic) IBOutlet UILabel *orderLb;
@property (weak, nonatomic) IBOutlet UILabel *scoialLb;
@property (weak, nonatomic) IBOutlet UILabel *BanBenLabel;
@property (weak, nonatomic) IBOutlet UILabel *HangYeLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLb1;
@property (weak, nonatomic) IBOutlet UILabel *dateLb2;


@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong) DDOpportunityModel * model;
@property (nonatomic,copy) void (^renLinBlock)();
@end

NS_ASSUME_NONNULL_END
