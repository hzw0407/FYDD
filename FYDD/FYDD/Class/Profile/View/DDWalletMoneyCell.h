//
//  DDWalletMoneyCell.h
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDWalletModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDWalletMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;

@property (nonatomic,copy) DDWalletModel * item;
@end

NS_ASSUME_NONNULL_END
