//
//  DDClerkTopCell.h
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDClerkTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

// 名称
@property (weak, nonatomic) IBOutlet UILabel *nameLb1;
@property (weak, nonatomic) IBOutlet UILabel *nameLb2;
@property (weak, nonatomic) IBOutlet UILabel *nameLb3;


@property (weak, nonatomic) IBOutlet UIImageView *iconView;
// 实施方
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UIView *progressiveView;
@property (weak, nonatomic) IBOutlet UILabel *starLb;
@property (weak, nonatomic) IBOutlet LCStarRatingView *starView;

// 企业用户
@property (weak, nonatomic) IBOutlet UILabel *moneLb;
@property (weak, nonatomic) IBOutlet UILabel *industryNameLb;
@property (weak, nonatomic) IBOutlet UILabel *companyLb;


@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons;

@property (copy,nonatomic) DDcommitButtonValueBlock event;


@end

NS_ASSUME_NONNULL_END
