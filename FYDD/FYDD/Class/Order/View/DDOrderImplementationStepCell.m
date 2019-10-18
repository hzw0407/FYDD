//
//  DDOrderImplementationStepCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderImplementationStepCell.h"
#import <SDWebImage/SDWebImage.h>
@implementation DDOrderImplementationStepCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)comfirmButtonDidClick:(UIButton *)sender {
    if (_comfirmBlock) {
        _comfirmBlock();
    }
}

- (void)setPlanModel:(DDOrderPlanModel *)planModel{
    _planModel = planModel;
    
    _stepLb.text = [NSString stringWithFormat:@"%zd",planModel.step];
    _stepNameLb.text = [NSString stringWithFormat:@"%@",planModel.detailTitle];
    _imageContentHeight.constant = planModel.imagesHeight;

    _commentIdeaLb.text = _planModel.userDetail;
    _commentIdeaCons.constant = _planModel.ideaHeight;
    
        _ideaLb.text = _planModel.onlineRemarks;
        _ideaConsLb.constant = _planModel.ideaHeight1;
    
    _eveNameLb1.text = yyTrimNullText(_planModel.evaluate1);
    _eveNameLb2.text = yyTrimNullText(_planModel.evaluate2);
    _eveaNameLb3.text = yyTrimNullText(_planModel.evaluate3);
    
    _eveStatusLb1.text = [_planModel convertEvaluate:_planModel.orderEvaluate1];
    _eveStatusLb2.text = [_planModel convertEvaluate:_planModel.orderEvaluate2];
    _eveStausLb3.text = [_planModel convertEvaluate:_planModel.orderEvaluate3];
    
    CGFloat left = 0;
    CGFloat top = 5;
    [_imageContentView removeAllSubviews];
    for (NSInteger i =0; i<planModel.imgs.count; i++) {
        UIButton * imageView = [UIButton new];
        imageView.size = CGSizeMake(planModel.imageWidth, planModel.imageWidth);
        if ((i) % 4 == 0 && i > 0) {
            top += planModel.imageWidth  + 10 ;
            left = 0;
        }else {
            left = (planModel.imageWidth  + 10 ) * (i % 4);
        }
        imageView.left = left ;
        imageView.top = top;
        imageView.tag = i;
        [imageView addTarget:self action:@selector(coverImageViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_planModel.imgs[i]] forState:UIControlStateNormal];
        [_imageContentView addSubview:imageView];
    }
    _statusLb.layer.borderWidth = 0;
    _statusLb.layer.borderColor = [UIColor clearColor].CGColor;
    _statusLb.selected = NO;
    _statusLb.layer.cornerRadius = 0;
    _statusLb.userInteractionEnabled = NO;
    if ([DDUserManager share].user.userType == DDUserTypeSystem) {
        if ([yyTrimNullText(_planModel.status) isEqualToString:@"0"]) {
            [_statusLb setTitle:@"审核" forState:UIControlStateNormal];
            _statusLb.layer.borderWidth = 1;
            _statusLb.layer.borderColor = UIColorHex(0xEF8200).CGColor;
            _statusLb.selected = YES;
            _statusLb.userInteractionEnabled = YES;
            _statusLb.layer.cornerRadius = 15;
            return;
        }
    }
    
    if ([yyTrimNullText(_planModel.status) isEqualToString:@"1"]) {
        _statusLb.selected = YES;
    }
    [_statusLb setTitle:_planModel.statusName forState:UIControlStateNormal];
        
}

- (void)coverImageViewDidClick:(UIButton *)btn{
    if (_coverImageDidClick) {
        _coverImageDidClick(_planModel.imgs[btn.tag],btn);
    }
}


@end
