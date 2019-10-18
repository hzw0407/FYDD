//
//  DDWelcomeVC.m
//  FYDD
//
//  Created by mac on 2019/2/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDWelcomeVC.h"
#import <Masonry/Masonry.h>

@interface DDWelcomeVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *welcomeBtn;

@end

@implementation DDWelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginButton.layer.borderColor = UIColorHex(0x549BF3).CGColor;
    [self setupUI];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupUI{
    _contentScrollView.contentSize = CGSizeMake(kScreenSize.width * 4, 0);
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    for( int i = 0 ; i < 4 ; i ++) {
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = UIColor.whiteColor;
        imageView.image =  [UIImage imageNamed:[NSString stringWithFormat:@"icon_welcome%d",i + 1]];
        [_contentScrollView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(i * kScreenSize.width, 0, kScreenSize.width, kScreenSize.height);
    }
}

- (IBAction)loginButtonDidClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:DD_LOGIN_NOTE object:nil];
}

- (IBAction)gotoMainVC {
    [DDUserManager share].isVisitorUser = YES;
    [[DDUserManager share] save];
    [[NSNotificationCenter defaultCenter] postNotificationName:DD_GOTO_MAIN object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_contentScrollView.contentOffset.x / kScreenSize.width == 3) {
        _loginButton.hidden = NO;
        _welcomeBtn.hidden = NO;
    }else {
        _loginButton.hidden = YES;
        _welcomeBtn.hidden = YES;
    }
}

@end
