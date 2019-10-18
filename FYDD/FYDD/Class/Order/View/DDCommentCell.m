//
//  DDCommentCell.m
//  FYDD
//
//  Created by mac on 2019/4/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDCommentCell.h"

@implementation DDCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _rateView0.type = 1;
    _rateView0.progress = 5;
    _rateView0.type = LCStarRatingViewCountingTypeInteger;
    @weakify(self)
    _rateView0.progressDidChangedByUser = ^(CGFloat progress) {
        @strongify(self)
        if (self.CommentBlock) {
            self.CommentBlock(0, progress);
        }
    };
    
    _rateView.type = 1;
    _rateView.progress = 5;
    _rateView.type = LCStarRatingViewCountingTypeInteger;
    _rateView.progressDidChangedByUser = ^(CGFloat progress) {
        @strongify(self)
        if (self.CommentBlock) {
            self.CommentBlock(1, progress);
        }
    };
    
    _rateView1.type = 1;
    _rateView1.progress = 5;
    _rateView1.type = LCStarRatingViewCountingTypeInteger;
    _rateView1.progressDidChangedByUser = ^(CGFloat progress) {
        @strongify(self)
        if (self.CommentBlock) {
            self.CommentBlock(2, progress);
        }
    };
}

@end
