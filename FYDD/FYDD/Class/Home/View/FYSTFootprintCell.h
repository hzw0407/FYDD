//
//  FYSTFootprintCell.h
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFootstripObj.h"
NS_ASSUME_NONNULL_BEGIN

@interface FYSTFootprintCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *countLB;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (nonatomic,strong) DDFootstripObj * footprintModel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

NS_ASSUME_NONNULL_END
