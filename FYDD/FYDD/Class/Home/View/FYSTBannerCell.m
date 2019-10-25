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
#import "DDProductObj.h"
#import "UIButton+FYCustonButton.h"
#import "DDMessageModel.h"

@interface FYSTBannerCell()<SDCycleScrollViewDelegate>
//{
//    NSTimer * _timer;
//    NSInteger _timerCount;
//}
//@property (weak, nonatomic) IBOutlet UIView *bannerPage;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;//广告图轮播
@property (nonatomic, strong) UILabel *bannerLabel;//banner当前页
@property (nonatomic, strong) NSArray *bannerArry;//广告图片数组
@property (nonatomic, strong) UIView *plateView;//板块view
@property (nonatomic, strong) UIView *newsView;//消息view
@property (nonatomic, strong) UIImageView *hornImageView;//喇叭图片
@property (nonatomic, strong) SDCycleScrollView *textCycleScrollView;//文字轮播
@property (nonatomic, strong) UIView *identityView;//身份view
@property (nonatomic, strong) UIView *materialView;//素材view
@property (nonatomic, strong) UIView *knowledgeView;//涨知识view

@end

@implementation FYSTBannerCell
#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.backgroundColor = UIColorHex(0xeeeeee);
        [self creatUI];
        
    }
    return self;
}

#pragma mark - CustomMethod
- (void)creatUI {
    [self addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.height.equalTo(@(210));
    }];
    
    [self addSubview:self.bannerLabel];
    [self.bannerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@(25));
        make.bottom.mas_equalTo(self.cycleScrollView.mas_bottom).offset(-30);
        make.height.equalTo(@(16));
    }];
    [self.bannerLabel layoutIfNeeded];
    self.bannerLabel.layer.cornerRadius = self.bannerLabel.size.height / 2;
    self.bannerLabel.clipsToBounds = YES;
    
    [self addSubview:self.plateView];
    [self.plateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.mas_equalTo(self.cycleScrollView.mas_bottom).offset(-20);
        make.height.equalTo(@(115));
    }];
    self.plateView.layer.cornerRadius = 10.0;
    
    [self addSubview:self.newsView];
    [self.newsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.mas_equalTo(self.plateView.mas_bottom).offset(20);
        make.height.equalTo(@(30));
    }];
    
    [self.newsView addSubview:self.hornImageView];
    [self.hornImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newsView).offset(10);
        make.width.equalTo(@(15));
        make.centerY.mas_equalTo(self.newsView.mas_centerY);
        make.height.equalTo(@(13));
    }];
    
    [self.newsView addSubview:self.textCycleScrollView];
    [self.textCycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hornImageView.mas_right).offset(10);
        make.right.equalTo(self.newsView).offset(-10);
        make.top.bottom.equalTo(self.newsView).offset(0);
    }];
    
    [self addSubview:self.identityView];
    [self.identityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(0);
        make.top.mas_equalTo(self.newsView.mas_bottom).offset(20);
        make.height.equalTo(@(45));
    }];
    
    CGFloat buttonWidth = (kScreenWidth - 50) / 2;
    UIButton *agentButton = [self.identityView viewWithTag:100];
    [agentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.identityView).offset(15);
        make.width.equalTo(@(buttonWidth));
        make.top.bottom.equalTo(self.identityView).offset(0);
    }];
    
    UIButton *implementerButton = [self.identityView viewWithTag:101];
    [implementerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.identityView).offset(-15);
        make.width.equalTo(@(buttonWidth));
        make.top.bottom.equalTo(self.identityView).offset(0);
    }];
    
    [self addSubview:self.materialView];
    [self.materialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(7.5);
        make.right.equalTo(self).offset(-7.5);
        make.top.mas_equalTo(self.identityView.mas_bottom).offset(10);
        make.height.equalTo(@(55));
    }];
    [self creattMaterialButton];
    
    [self addSubview:self.knowledgeView];
    [self.knowledgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(0);
        make.top.mas_equalTo(self.materialView.mas_bottom).offset(30);
        make.height.equalTo(@(25));
    }];
    
    UIImageView *lineImageView = [self.knowledgeView viewWithTag:300];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.knowledgeView).offset(10);
        make.width.equalTo(@(5));
        make.centerY.mas_equalTo(self.knowledgeView.mas_centerY);
        make.height.equalTo(@(15));
    }];
    
    UILabel *knowledgeLabel = [self.knowledgeView viewWithTag:301];
    [knowledgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineImageView.mas_right).offset(5);
        make.right.equalTo(self.knowledgeView).offset(0);
        make.top.bottom.equalTo(self.knowledgeView).offset(0);
    }];
}

//刷新广告数据
- (void)refreshWithArray:(NSArray *)banners {
    NSMutableArray *imageArray = [NSMutableArray array];
    for (DDBannerModel *model in banners) {
        [imageArray addObject:model.imageUrl];
    }
    self.bannerArry = imageArray;
    //默认显示第一张图
    self.bannerLabel.text = [NSString stringWithFormat:@"1/%zd",imageArray.count];
    self.cycleScrollView.imageURLStringsGroup = imageArray;
}

//刷新板块数据
- (void)refreshPlateWithArray:(NSArray *)plateArray {
    [self.plateView removeAllSubviews];
    CGFloat buttonWidth = (kScreenWidth - 20) / plateArray.count;
    for (NSInteger i = 0; i < plateArray.count; i++) {
        DDProductObj * obj = plateArray[i];
        UIButton *plateButton = [[UIButton alloc] init];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:obj.backImg] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            UIImage *targetImage = [self originImage:image scaleToSize:CGSizeMake(66, 66)];
            [plateButton setImage:targetImage forState:UIControlStateNormal];
        }];
        //先暂时用效果图的 后面要改成上面的
//        [plateButton setImage:[UIImage imageNamed:@"Test"] forState:UIControlStateNormal];
        [plateButton setTitle:obj.productName forState:UIControlStateNormal];
        [plateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        plateButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [plateButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:2];
        plateButton.tag = i;
        [plateButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.plateView addSubview:plateButton];
        [plateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.plateView).offset(buttonWidth * i);
            make.width.equalTo(@(buttonWidth));
            make.top.equalTo(@(15));
            make.height.equalTo(@(85));
        }];
    }
}

//修改图片大小
- (UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//刷新消息数据
- (void)refreshMessageWithArray:(NSArray *)messAgeArray {
    NSMutableArray *array = [NSMutableArray array];
    for (DDMessageModel *objc in messAgeArray) {
        [array addObject:objc.messageContent];
    }
    self.textCycleScrollView.titlesGroup = array;
//    self.textCycleScrollView.titlesGroup = @[@"11",@"22",@"33"];
}

//创建素材按钮
- (void)creattMaterialButton {
    CGFloat buttonWidth = (kScreenWidth - 15) / 3;
    NSArray *imageArray = @[@"Home_Step",@"Home_Video",@"Home_Case"];
    NSArray *nameArray = @[@"实施步骤",@"演示视频",@"成功案例"];
    for (NSInteger i = 0; i < imageArray.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"Home_Material"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        button.tag = 200 + i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.materialView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.materialView).offset(buttonWidth * i);
            make.width.equalTo(@(buttonWidth));
            make.top.bottom.equalTo(self.materialView).offset(0);
        }];
    }
}

#pragma mark - ClickMethod
- (void)btnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFunction:)]) {
        [self.delegate clickFunction:btn.tag];
    }
}

#pragma mark - SystemDelegate

#pragma mark - CustomDelegate

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (cycleScrollView == self.cycleScrollView) {
        //广告
        if (_bannerDidClick) {
            _bannerDidClick(index);
        }
    }else {
        //消息
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickMessage:)]) {
            [self.delegate clickMessage:index];
        }
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    if (cycleScrollView == self.cycleScrollView) {
        //广告
        self.bannerLabel.text = [NSString stringWithFormat:@"%zd/%zd",index + 1,self.bannerArry.count];
    }
}

#pragma mark - GetterAndSetter
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.delegate = self;
        _cycleScrollView.showPageControl = NO;
    }
    return _cycleScrollView;
}

- (UILabel *)bannerLabel {
    if (!_bannerLabel) {
        _bannerLabel = [[UILabel alloc] init];
        _bannerLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _bannerLabel.textColor = [UIColor whiteColor];
        _bannerLabel.font = [UIFont systemFontOfSize:10];
        _bannerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bannerLabel;
}

- (NSArray *)bannerArry {
    if (!_bannerArry) {
        _bannerArry = [NSArray array];
    }
    return _bannerArry;
}

- (UIView *)plateView {
    if (!_plateView) {
        _plateView = [[UIView alloc] init];
        _plateView.backgroundColor = [UIColor whiteColor];
        
        //添加阴影效果
        _plateView.layer.masksToBounds = false;
        _plateView.layer.shadowOffset = CGSizeMake(0, 3);
        _plateView.layer.shadowOpacity = 0.3;
        _plateView.layer.shadowRadius = 3;
        _plateView.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    return _plateView;
}

- (UIView *)newsView {
    if (!_newsView) {
        _newsView = [[UIView alloc] init];
        _newsView.backgroundColor = [STTool colorWithHexString:@"#F9F9F9" alpha:1.0];
    }
    return _newsView;
}

- (UIImageView *)hornImageView {
    if (!_hornImageView) {
        _hornImageView = [[UIImageView alloc] init];
        _hornImageView.image = [UIImage imageNamed:@"icon_notice1"];
    }
    return _hornImageView;
}

- (SDCycleScrollView *)textCycleScrollView {
    if (!_textCycleScrollView) {
        _textCycleScrollView = [[SDCycleScrollView alloc] init];
        _textCycleScrollView.delegate = self;
        //只轮播文字
        _textCycleScrollView.onlyDisplayText = YES;
        //轮播文字颜色
        _textCycleScrollView.titleLabelTextColor = [STTool colorWithHexString:@"#ABAEB1" alpha:1.0];
        //轮播文字背景颜色
        _textCycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        //文字大小
        _textCycleScrollView.titleLabelTextFont = [UIFont systemFontOfSize:14];
    }
    return _textCycleScrollView;
}

- (UIView *)identityView {
    if (!_identityView) {
        _identityView = [[UIView alloc] init];
        _identityView.backgroundColor = [UIColor whiteColor];
        
        //代理方
        UIButton *agentButton = [[UIButton alloc] init];
        [agentButton setBackgroundImage:[UIImage imageNamed:@"Home_BackGround"] forState:UIControlStateNormal];
        [agentButton setTitle:@"代理方" forState:UIControlStateNormal];
        [agentButton setImage:[UIImage imageNamed:@"Home_Agent"] forState:UIControlStateNormal];
        [agentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        agentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        agentButton.tag = 100;
        [agentButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [agentButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:20];
        [_identityView addSubview:agentButton];
        
        
        //实施方
        UIButton *implementerButton = [[UIButton alloc] init];
        [implementerButton setBackgroundImage:[UIImage imageNamed:@"Home_BackGround"] forState:UIControlStateNormal];
        [implementerButton setTitle:@"实施方" forState:UIControlStateNormal];
        [implementerButton setImage:[UIImage imageNamed:@"Home_Implementer"] forState:UIControlStateNormal];
        [implementerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        implementerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        implementerButton.tag = 101;
        [implementerButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [implementerButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:20];
        [_identityView addSubview:implementerButton];
        
    }
    return _identityView;
}

- (UIView *)materialView {
    if (!_materialView) {
        _materialView = [[UIView alloc] init];
    }
    return _materialView;
}

- (UIView *)knowledgeView {
    if (!_knowledgeView) {
        _knowledgeView = [[UIView alloc] init];
        
        //竖线
        UIImageView *lineImageView = [[UIImageView alloc] init];
        lineImageView.image = [UIImage imageNamed:@"Home_Line"];
        lineImageView.tag = 300;
        [_knowledgeView addSubview:lineImageView];
        
        //标题
        UILabel *knowledgeLabel = [[UILabel alloc] init];
        knowledgeLabel.text = @"涨知识";
        knowledgeLabel.textColor = [UIColor blackColor];
        knowledgeLabel.font = [UIFont systemFontOfSize:18];
        knowledgeLabel.tag = 301;
        [_knowledgeView addSubview:knowledgeLabel];
    }
    return _knowledgeView;
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
