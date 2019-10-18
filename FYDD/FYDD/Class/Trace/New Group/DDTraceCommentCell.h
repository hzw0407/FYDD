//
//  DDTraceCommentCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/12.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFootstripObj.h"

@interface DDTraceCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *userLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (nonatomic,strong) DDFootstripComment * stripments;
@end

