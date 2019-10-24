//
//  STAdvertorialsDetailVC.m
//  FYDD
//
//  Created by 何志武 on 2019/10/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//  --软文详情

#import "STAdvertorialsDetailVC.h"

@interface STAdvertorialsDetailVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) UIButton *shareButton;//分享按钮

@end

@implementation STAdvertorialsDetailVC
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    
    [self.view addSubview:self.scrollView];
    
}

#pragma mark - CustomMethod

#pragma mark - ClickMethod
//点击分享
- (void)rightClick {
    
}

#pragma mark - SystemDelegate

#pragma mark - CustomDelegate

#pragma mark - GetterAndSetter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, kScreenWidth - 20, 0)];
        titleLabel.text = self.model.title;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.numberOfLines = 0;
        titleLabel.tag = 100;
        [_scrollView addSubview:titleLabel];
        CGFloat titleHeight = [STTool calculateHeight:titleLabel.text fontSize:18 width:(kScreenWidth - 20)];
        titleLabel.height = titleHeight;

        //发布时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30 + titleHeight + 10, kScreenWidth - 100, 20)];
        NSDateFormatter * formater = [NSDateFormatter new];
        formater.dateFormat = @"yyyy-MM-ddTHH:mm:ss";
        self.model.updateTime = [self.model.updateTime stringByReplacingOccurrencesOfString:@".000+0000" withString:@""];
        if ([self.model.updateTime componentsSeparatedByString:@"T"].count > 0) {
            timeLabel.text = [NSString stringWithFormat:@"发布时间:%@",[self.model.updateTime componentsSeparatedByString:@"T"][0]];
            }
        timeLabel.textColor = [STTool colorWithHexString:@"#ABAEB1" alpha:1];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.tag = 101;
        [_scrollView addSubview:timeLabel];

        //浏览量图片
        UIImageView *browseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 30 + titleHeight + 10 + 3.5, 21.5, 13)];
        browseImageView.image = [UIImage imageNamed:@"Home_Eye"];
        browseImageView.tag = 102;
        [_scrollView addSubview:browseImageView];

        //浏览量
        UILabel *browseLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 27, 30 + titleHeight + 10, 17, 20)];
        browseLabel.text = [NSString stringWithFormat:@"%zd",self.model.commentNumber];
        browseLabel.textColor = [STTool colorWithHexString:@"#ABAEB1" alpha:1];
        browseLabel.font = [UIFont systemFontOfSize:12];
        browseLabel.textAlignment = NSTextAlignmentRight;
        browseLabel.tag = 103;
        [_scrollView addSubview:browseLabel];

        //内容
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30 + titleHeight + 10 + 20 + 20, kScreenWidth - 20, 0)];
        contentLabel.text = self.model.contents;
        contentLabel.textColor = [STTool colorWithHexString:@"#56585A" alpha:1];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.numberOfLines = 0;
        contentLabel.tag = 104;
        [_scrollView addSubview:contentLabel];
        CGFloat contentHeight = [STTool calculateHeight:contentLabel.text fontSize:14 width:(kScreenWidth - 20)];
        contentLabel.height = contentHeight;

        //内容图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30 + titleHeight + 20 + 20 + 20 + contentHeight + 10, kScreenWidth - 20, 190)];
        if (self.model.showImage) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.showImage] placeholderImage:[UIImage imageNamed:@"index_place"]];
        }
        imageView.tag = 105;
        [_scrollView addSubview:imageView];
        
        _scrollView.contentSize = CGSizeMake(0, 30 + titleHeight + 10 + 20 + contentHeight + 20 + 30 + 190 + 10);
    }
    return _scrollView;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 16)];
        [_shareButton setImage:[UIImage imageNamed:@"Home_Share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}


@end
