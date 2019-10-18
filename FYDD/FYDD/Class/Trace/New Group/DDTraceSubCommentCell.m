//
//  DDTraceSubCommentCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/27.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDTraceSubCommentCell.h"

@implementation DDTraceSubCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStripments:(DDFootstripComment *)stripments{
    _stripments = stripments;
    if (yyTrimNullText(stripments.createUserLogo).length > 0) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:stripments.createUserLogo]];
    }else {
        _iconView.image = [UIImage imageNamed:[DDUserManager share].userPlaceImage];
    }
    
    _userLb.text = yyTrimNullText(stripments.createUserName);
    NSArray * dataList = [yyTrimNullText(stripments.createTime) componentsSeparatedByString:@"T"];
    if ([yyTrimNullText(stripments.createTime) componentsSeparatedByString:@"T"].count > 0){
        _timeLb.text = dataList[0];
    }
    
    _contentLb.text = yyTrimNullText(stripments.commnet);
}


@end
