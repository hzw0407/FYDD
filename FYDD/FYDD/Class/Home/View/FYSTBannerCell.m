//
//  FYSTBannerCell.m
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "FYSTBannerCell.h"
#import <SDWebImage/SDWebImage.h>
#import "SDCycleScrollView.h"

@interface FYSTBannerCell()<SDCycleScrollViewDelegate>
//{
//    NSTimer * _timer;
//    NSInteger _timerCount;
//}
//@property (weak, nonatomic) IBOutlet UIView *bannerPage;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation FYSTBannerCell
#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.cycleScrollView];
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.bottom.equalTo(self).offset(0);
        }];
        
    }
    return self;
}

#pragma mark - CustomMethod
- (void)refreshWithArray:(NSArray *)banners {
    NSMutableArray *imageArray = [NSMutableArray array];
    for (DDBannerModel *model in banners) {
        [imageArray addObject:model.imageUrl];
    }
    self.cycleScrollView.imageURLStringsGroup = imageArray;
}

#pragma mark - ClickMethod

#pragma mark - SystemDelegate

#pragma mark - CustomDelegate

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (_bannerDidClick) {
        _bannerDidClick(index);
    }
}

#pragma mark - GetterAndSetter
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.delegate = self;
        
    }
    return _cycleScrollView;
}

//- (void)awakeFromNib{
//    [super awakeFromNib];
//    _contentScrolView.pagingEnabled = YES;
//    _contentScrolView.delegate = self;
//    _contentScrolView.showsVerticalScrollIndicator = NO;
//    _contentScrolView.showsHorizontalScrollIndicator = NO;
//
//    _contentScrolView.backgroundColor = [UIColor blueColor];
//
//}
//
//- (void)setBanners:(NSArray *)banners{
//    _banners = banners;
//    [_contentScrolView removeAllSubviews];
//
//    [_bannerPage removeAllSubviews];
//    for (NSInteger i =0; i < _banners.count; i++) {
//        DDBannerModel * model = _banners[i];
//        UIButton * imageView = [UIButton new];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:yyTrimNullText(model.imageUrl)] forState:UIControlStateNormal];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.frame = CGRectMake((kScreenSize.width) * i + 10, 0, kScreenSize.width - 20, 240);
//        UIView * lineView = [self getBannerPageView];
//        [_contentScrolView addSubview:imageView];
//        if (i > 0) {
//            lineView.backgroundColor = UIColorHex(0xF3F4F6);
//        }
//        imageView.tag = i;
//        [imageView addTarget:self action:@selector(bannerButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
//        lineView.frame = CGRectMake(27 * i, 15, 19 , 3);
//        lineView.tag = i + 10;
//        [_bannerPage addSubview:lineView];
//    }
//    _currentPageView = [_bannerPage viewWithTag:10];
//    _bannerPage.width = 27 * _banners.count;
//    _bannerPage.height = 30;
//    _bannerPage.top = 235;
//    _bannerPage.centerX = kScreenSize.width * 0.5;
//    if (_banners.count == 1) return;
//    _timerCount = 0;
//    if (_timer) {
//        [_timer invalidate];
//        _timer = nil;
//    }
//    _contentScrolView.contentSize = CGSizeMake(kScreenSize.width * _banners.count, 0);
//    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scheduledTimer) userInfo:nil repeats:YES];
//}
//
//- (void)bannerButtonDidClick:(UIButton *)btn{
//    if (_bannerDidClick) {
//        _bannerDidClick(btn.tag);
//    }
//}
//
//- (void)scheduledTimer{
//
//    _timerCount +=1;
//    if (_timerCount >= _banners.count) {
//        _timerCount = 0;
//    }
//    [self setCurrentPage:_timerCount];
//    [_contentScrolView setContentOffset:CGPointMake((kScreenSize.width) * _timerCount , 0) animated:YES];
//}
//
//- (void)setCurrentPage:(NSInteger)page{
//    _currentPageView.backgroundColor = UIColorHex(0xF3F4F6);
//    _currentPageView = [_bannerPage viewWithTag:page + 10];
//    _currentPageView.backgroundColor = UIColorHex(0x2996EB);
//}
//
//- (UIView *)getBannerPageView{
//    UIView * view = [UIView new];
//    view.backgroundColor = UIColorHex(0x2996EB);
//    view.bounds = CGRectMake(0, 0, 19, 3);
//    view.layer.cornerRadius = 1.5;
//    view.layer.masksToBounds = YES;
//    return view;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    _timerCount = scrollView.contentOffset.x / kScreenSize.width;
//    [self setCurrentPage:_timerCount];
//}


@end
