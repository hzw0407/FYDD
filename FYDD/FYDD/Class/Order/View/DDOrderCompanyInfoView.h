//
//  DDOrderCompanyInfoView.h
//  FYDD
//
//  Created by wenyang on 2019/9/6.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOrderInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDOrderCompanyInfoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *topTintView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLb;
@property (weak, nonatomic) IBOutlet UILabel *companyIndustryLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic)  UIButton *tempButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (copy,nonatomic) DDcommitButtonValueBlock event;
@end

NS_ASSUME_NONNULL_END
