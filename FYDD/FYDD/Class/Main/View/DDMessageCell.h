//
//  DDMessageCell.h
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *dayDate;

@end

NS_ASSUME_NONNULL_END
