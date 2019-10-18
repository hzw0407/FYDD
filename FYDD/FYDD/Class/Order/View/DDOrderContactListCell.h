//
//  DDOrderContactListCell.h
//  FYDD
//
//  Created by mac on 2019/4/27.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDOrderContactListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contactNameLb;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (copy, nonatomic) DDcommitButtonBlock event;
@end

NS_ASSUME_NONNULL_END
