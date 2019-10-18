//
//  DDOrderRenewCell.h
//  FYDD
//
//  Created by mac on 2019/4/29.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOrderDetailInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDOrderRenewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLb;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLb;
@property (weak, nonatomic) IBOutlet UILabel *textLb4;
@property (weak, nonatomic) IBOutlet UILabel *textLb5;
@property (nonatomic,strong) DDOrderDetailInfo * info;
@end

NS_ASSUME_NONNULL_END
