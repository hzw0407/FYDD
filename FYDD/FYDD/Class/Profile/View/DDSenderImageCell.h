//
//  DDSenderImageCell.h
//  FYDD
//
//  Created by mac on 2019/4/15.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDSenderImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (nonatomic,assign) NSInteger indexPath_row;
@property (nonatomic,copy) void (^SenderImageBlock)(DDSenderImageCell * cell) ;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@end

NS_ASSUME_NONNULL_END
