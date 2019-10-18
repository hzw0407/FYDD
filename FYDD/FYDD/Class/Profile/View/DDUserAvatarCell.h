//
//  DDUserAvatarCell.h
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDUserAvatarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIImageView *dictView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;

@end

NS_ASSUME_NONNULL_END
