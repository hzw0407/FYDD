//
//  DDChatSendCell.h
//  FYDD
//
//  Created by mac on 2019/4/15.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDChatModel.h"


@interface DDChatSendCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *contentLb;
//@property (weak, nonatomic) IBOutlet UIImageView *iconView;
//@property (weak, nonatomic) IBOutlet UILabel *dateLb;
//@property (weak, nonatomic) IBOutlet UIImageView *chatImageView;

//刷新数据
- (void)refreshWithModel:(DDChatModel *)model;

@end


