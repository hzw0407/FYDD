//
//  DDVideoListCell.m
//  FYDD
//
//  Created by mac on 2019/4/29.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDVideoListCell.h"
#import <UIImageView+WebCache.h>
@implementation DDVideoListCell

- (void)setVideo:(DDVideoListModel *)video{
    _video = video;
    _nameLb.text = yyTrimNullText(video.title);
    if (yyTrimNullText(video.coverUrl).length > 0) {
        [_coverView sd_setImageWithURL:[NSURL URLWithString:yyTrimNullText(video.coverUrl)]];
    }else {
        _coverView.image = nil;
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    BMPlayer * player = [BMPlayer new];
    
    
}


@end
