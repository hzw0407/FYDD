//
//  DDWalletTopCell.h
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDWalletTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons;
@property (weak, nonatomic) IBOutlet UIView *walletMenuView;
@property (weak, nonatomic) IBOutlet UILabel *shenyuLb;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (copy,nonatomic) DDcommitButtonValueBlock event;
@end

NS_ASSUME_NONNULL_END
