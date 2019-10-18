//
//  DDQuestionItemCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDQuestionItemCell.h"

@implementation DDQuestionItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRecordObj:(DDRequstionRecordObj *)recordObj{
    _recordObj = recordObj;
    _questionLb.layer.borderWidth = 0;
    if ([yyTrimNullText(recordObj.userAnswer) isEqualToString:yyTrimNullText(recordObj.result)] && yyTrimNullText(recordObj.userAnswer).length) {
        _questionLb.backgroundColor = [UIColor colorWithRed:59/255.0 green:228/255.0 blue:159/255.0 alpha:0.2];
        _questionLb.textColor = [UIColor colorWithRed:59/255.0 green:228/255.0 blue:159/255.0 alpha:1];
    }else  if (yyTrimNullText(recordObj.userAnswer).length > 0) {
        _questionLb.backgroundColor = [UIColor colorWithRed:241/255.0 green:75/255.0 blue:66/255.0 alpha:0.2];
        _questionLb.textColor = [UIColor colorWithRed:241/255.0 green:75/255.0 blue:66/255.0 alpha:1];
    }else {
        _questionLb.backgroundColor = [UIColor whiteColor];
        _questionLb.textColor = UIColorHex(0xABAEB1);
        _questionLb.layer.borderWidth = 1;
        _questionLb.layer.borderColor = UIColorHex(0xABAEB1).CGColor;
    }
}

@end
