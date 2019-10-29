//
//  DDCarryUserCell3.m
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDCarryUserCell3.h"
#import "DDOrdeStepImageView.h"

@implementation DDCarryUserCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    _nextButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _nextButton.layer.shadowOffset = CGSizeMake(0,3);
    _nextButton.layer.shadowRadius = 6;
    _nextButton.layer.shadowOpacity = 1;
    _nextButton.layer.cornerRadius = 20;
    
    _textContentView.layer.borderWidth = 1;
    _textContentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _textContentView.layer.cornerRadius = 10;
    _textContentView.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
    _textView.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (_textChangeBlock) _textChangeBlock(textView.text);
}

- (void)setUrls:(NSArray *)urls{
    _urls = urls;
    [_scrollView removeAllSubviews];
    double width = (kScreenSize.width - 120) / 3;
    double left = 0;
    double top = 0;
    for (NSInteger i =0; i <=_urls.count ; i++) {
        DDOrdeStepImageView * stepView = [self getStepImageView];
        if ((i) % 3 == 0 && i > 0) {
            top += width;
            left = 0;
        }else {
            left = (width)*(i % 3);
        }
        if (i == _urls.count) {
            stepView.iconView.image = [UIImage imageNamed:@"icon_upload_img"];
            stepView.closeBtn.hidden = YES;
        }else {
            stepView.closeBtn.hidden = NO;
            [stepView.iconView sd_setImageWithURL:[NSURL URLWithString:_urls[i]]];
        }
        
        stepView.tag = i;
        stepView.left = left;
        stepView.top = top;
        stepView.size = CGSizeMake(width, width);
        [_scrollView addSubview:stepView];
    }

}

- (DDOrdeStepImageView *)getStepImageView{
    DDOrdeStepImageView * stepView = [[[NSBundle mainBundle] loadNibNamed:@"DDOrdeStepImageView" owner:nil options:nil] lastObject];
    @weakify(self)
    @weakify(stepView);
    stepView.stepOrderButtonDidClick = ^(NSInteger index) {
        @strongify(self)
        if (!self) return ;
        if (index == 0) {
            [weak_stepView removeFromSuperview];
            if (self.removeBlock) self.removeBlock(weak_stepView.tag);
        }else {
            if (weak_stepView.tag == self->_urls.count) {
                if (self.addBlock) self.addBlock();
            }else {
                if (self.showBlock) self.showBlock(weak_stepView.iconView, self.urls[weak_stepView.tag]);
            }
        }
    };
    return stepView;
}

- (IBAction)commitButtonDidClick:(UIButton *)sender {
    if (_commitBlock) _commitBlock();
}


@end
