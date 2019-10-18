//
//  DDOpportunityDetailCell.h
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"
#import "DDOpportunityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDOpportunityDetailCell : UITableViewCell
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
@property (weak, nonatomic) IBOutlet LCStarRatingView *rateView;
@property (nonatomic,strong) DDOpportunityModel * appModel;
@property (weak, nonatomic) IBOutlet UILabel *contactLb;
@property (weak, nonatomic) IBOutlet UILabel *contantPhoneLb;
@property (nonatomic,copy) void (^renlinBlock)(void);
@property (nonatomic,copy) void (^orderBtnBlock)(void);
@end

NS_ASSUME_NONNULL_END
