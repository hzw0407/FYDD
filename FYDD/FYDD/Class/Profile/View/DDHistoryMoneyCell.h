//
//  DDHistoryMoneyCell.h
//  FYDD
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBankModelHistoryModel.h"


@interface DDHistoryMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bankNameLb;
@property (weak, nonatomic) IBOutlet UILabel *bankDateLb;
@property (weak, nonatomic) IBOutlet UILabel *moneLb;

@property (nonatomic,strong) DDBankModelHistoryModel * item;
@end


