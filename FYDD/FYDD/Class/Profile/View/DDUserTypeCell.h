//
//  DDUserTypeCell.h
//  FYDD
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDUserTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *userLb;
@property (weak, nonatomic) IBOutlet UILabel *textLb1;
@property (weak, nonatomic) IBOutlet UILabel *textLb2;
@property (strong,nonatomic) NSIndexPath * indexpath;
@property (weak, nonatomic) IBOutlet UIView *statusTypeLb;

@property (nonatomic,assign) DDUserType showType;
@end

NS_ASSUME_NONNULL_END
