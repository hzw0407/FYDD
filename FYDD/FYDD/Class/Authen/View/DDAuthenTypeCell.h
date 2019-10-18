//
//  DDAuthenTypeCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDAuthenTypeCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *exmaViews;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *textLb1;
@property (weak, nonatomic) IBOutlet UILabel *textLb2;
@property (weak, nonatomic) IBOutlet UIButton *shouquanshuButton;
@property (weak, nonatomic) IBOutlet UIView *examinationView;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIButton *startExaminationButton;

@property (weak, nonatomic) IBOutlet UIButton *verifyView;
@property (nonatomic,assign) DDUserType userType;

@property (nonatomic,copy) void (^authorizeBlock)(DDUserType userType);
@property (nonatomic,copy) void (^applyBlock)(DDUserType userType);
@property (nonatomic,copy) void (^menuBlock)(DDUserType userType,NSInteger index);
@end

NS_ASSUME_NONNULL_END
