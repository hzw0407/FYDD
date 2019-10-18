//
//  FYSTBannerCell.m
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "FYSTBannerCell.h"
#import <SDWebImage/SDWebImage.h>
@interface FYSTBannerCell(){
    NSTimer * _timer;
    NSInteger _timerCount;
}
@property (weak, nonatomic) IBOutlet UIView *bannerPage;

@end

@implementation FYSTBannerCell

- (void)awakeFromNib{
    [super awakeFromNib];
    _contentScrolView.pagingEnabled = YES;
    _contentScrolView.delegate = self;
    _contentScrolView.showsVerticalScrollIndicator = NO;
    _contentScrolView.showsHorizontalScrollIndicator = NO;
    
}

- (void)setBanners:(NSArray *)banners{
    _banners = banners;
    [_contentScrolView removeAllSubviews];
    
    [_bannerPage removeAllSubviews];
    for (NSInteger i =0; i < _banners.count; i++) {
        DDBannerModel * model = _banners[i];
        UIButton * imageView = [UIButton new];
        [imageView sd_setImageWithURL:[NSURL URLWithString:yyTrimNullText(model.imageUrl)] forState:UIControlStateNormal];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake((kScreenSize.width) * i + 10, 0, kScreenSize.width - 20, 240);
        UIView * lineView = [self getBannerPageView];
        [_contentScrolView addSubview:imageView];
        if (i > 0) {
            lineView.backgroundColor = UIColorHex(0xF3F4F6);
        }
        imageView.tag = i;
        [imageView addTarget:self action:@selector(bannerButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        lineView.frame = CGRectMake(27 * i, 12, 19 , 3);
        lineView.tag = i + 10;
        [_bannerPage addSubview:lineView];
    }
    _currentPageView = [_bannerPage viewWithTag:10];
    _bannerPage.width = 27 * _banners.count;
    _bannerPage.height = 30;
    _bannerPage.top = 235;
    _bannerPage.centerX = kScreenSize.width * 0.5;
    if (_banners.count == 1) return;
    _timerCount = 0;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _contentScrolView.contentSize = CGSizeMake(kScreenSize.width * _banners.count, 0);
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scheduledTimer) userInfo:nil repeats:YES];
}

- (void)bannerButtonDidClick:(UIButton *)btn{
    if (_bannerDidClick) {
        _bannerDidClick(btn.tag);
    }
}

- (void)scheduledTimer{
    
    _timerCount +=1;
    if (_timerCount >= _banners.count) {
        _timerCount = 0;
    }
    [self setCurrentPage:_timerCount];
    [_contentScrolView setContentOffset:CGPointMake((kScreenSize.width) * _timerCount , 0) animated:YES];
}

- (void)setCurrentPage:(NSInteger)page{
    _currentPageView.backgroundColor = UIColorHex(0xF3F4F6);
    _currentPageView = [_bannerPage viewWithTag:page + 10];
    _currentPageView.backgroundColor = UIColorHex(0x2996EB);
}

- (UIView *)getBannerPageView{
    UIView * view = [UIView new];
    view.backgroundColor = UIColorHex(0x2996EB);
    view.bounds = CGRectMake(0, 0, 19, 3);
    view.layer.cornerRadius = 1.5;
    view.layer.masksToBounds = YES;
    return view;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _timerCount = scrollView.contentOffset.x / kScreenSize.width;
    [self setCurrentPage:_timerCount];
}


@end
