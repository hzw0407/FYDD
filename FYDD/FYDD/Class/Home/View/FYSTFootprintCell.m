//
//  FYSTFootprintCell.m
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "FYSTFootprintCell.h"
#import <SDWebImage/SDWebImage.h>
@implementation FYSTFootprintCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFootprintModel:(DDFootstripObj *)footprintModel{
    _footprintModel = footprintModel;
    _nameLb.text = _footprintModel.title;
    _userNameLb.text = footprintModel.createUserName;
    _countLB.text = [NSString stringWithFormat:@"%zd",_footprintModel.commentNumber];
    if (footprintModel.showImage) {
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:footprintModel.showImage] placeholderImage:[UIImage imageNamed:@"index_place"]];
    }
    if (yyTrimNullText(_footprintModel.createUserLogo).length > 0) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:yyTrimNullText(_footprintModel.createUserLogo)]];
    }else {
        _iconView.image = [UIImage imageNamed:[[DDUserManager share] userPlaceImage]];
    }
    NSDateFormatter * formater = [NSDateFormatter new];
    formater.dateFormat = @"yyyy-MM-ddTHH:mm:ss";
    _footprintModel.updateTime = [_footprintModel.updateTime stringByReplacingOccurrencesOfString:@".000+0000" withString:@""];
    if ([_footprintModel.updateTime componentsSeparatedByString:@"T"].count > 0) {
        _timeLb.text = [_footprintModel.updateTime componentsSeparatedByString:@"T"][0];
    }
}

@end
