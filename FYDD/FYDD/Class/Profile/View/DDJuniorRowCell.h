//
//  DDJuniorRowCell.h
//  FYDD
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDJuniorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDJuniorRowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLb1;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLb;
@property (weak, nonatomic) IBOutlet UILabel *countLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;

@property (nonatomic,strong) DDJuniorModel * model;
@end

NS_ASSUME_NONNULL_END
