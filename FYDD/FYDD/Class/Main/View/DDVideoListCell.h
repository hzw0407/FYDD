//
//  DDVideoListCell.h
//  FYDD
//
//  Created by mac on 2019/4/29.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDVideoListModel.h"
#import <BMPlayer-Swift.h>


@interface DDVideoListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (nonatomic,strong) DDVideoListModel * video;
@property (weak, nonatomic) IBOutlet UIImageView *videoViewImage;

@end


