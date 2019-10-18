//
//  DDBaseCell.h
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDBaseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIImageView *dictView;
@property (weak, nonatomic) IBOutlet UISwitch *switchOn;
@property (nonatomic, copy) DDcommitButtonValueBlock event;
@end

NS_ASSUME_NONNULL_END
