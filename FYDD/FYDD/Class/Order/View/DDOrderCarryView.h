//
//  DDOrderCarryView.h
//  FYDD
//
//  Created by wenyang on 2019/9/6.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"
#import "DDOrderInfo.h"

NS_ASSUME_NONNULL_BEGIN
@interface DDOrderCarryView : UIView
@property (weak, nonatomic) IBOutlet UIView *topTintView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet LCStarRatingView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *ingButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic)  UIButton *tempButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (copy,nonatomic) DDcommitButtonValueBlock event;
@property (nonatomic,strong) DDOrderCheckUser * checkUser;
@property (nonatomic,strong) DDOrderExtensionUser * extensionUser;
@end

NS_ASSUME_NONNULL_END
