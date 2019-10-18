//
//  DDUserAgreeInfoCell.h
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDUserAgreeInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (assign,nonatomic) BOOL isSelected;
@property (nonatomic,copy) DDcommitButtonBlock event;
@end

NS_ASSUME_NONNULL_END
