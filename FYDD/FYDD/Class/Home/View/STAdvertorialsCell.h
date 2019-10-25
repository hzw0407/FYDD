//
//  STAdvertorialsCell.h
//  FYDD
//
//  Created by 何志武 on 2019/10/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFootstripObj.h"
#import "STAdvertorialsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface STAdvertorialsCell : UITableViewCell

//刷新数据
- (void)refreshWithModel:(STAdvertorialsModel *)model;

@end

NS_ASSUME_NONNULL_END
