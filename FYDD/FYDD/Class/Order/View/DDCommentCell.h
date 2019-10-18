//
//  DDCommentCell.h
//  FYDD
//
//  Created by mac on 2019/4/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"



@interface DDCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;

@property (weak, nonatomic) IBOutlet UILabel *codeNameLb1;
@property (weak, nonatomic) IBOutlet UILabel *codeNameLb2;
@property (weak, nonatomic) IBOutlet UILabel *codeNameLb3;

@property (weak, nonatomic) IBOutlet LCStarRatingView *rateView0;
@property (weak, nonatomic) IBOutlet LCStarRatingView *rateView;
@property (weak, nonatomic) IBOutlet LCStarRatingView *rateView1;


@property (nonatomic,copy) void (^CommentBlock)(NSInteger type , CGFloat progressive);
@end


