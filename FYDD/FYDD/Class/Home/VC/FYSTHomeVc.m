//
//  FYSTHomeVc.m
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "FYSTHomeVc.h"
#import "FYSTBannerCell.h"
#import <MJRefresh/MJRefresh.h>
#import "FYSTHomeUserView.h"
#import "FYSTRightItemMenuView.h"
#import "DDMessageVC.h"
#import <CWLateralSlide/UIViewController+CWLateralSlide.h>
#import "DDProfileVC.h"
#import "DDAuthenVc.h"
#import "DDFootstripObj.h"
#import "DDProductObj.h"
#import "DDProductDetailVC.h"
#import "DDOrderVC.h"
#import "DDWebVC.h"
#import "DDTradeDetailVc.h"
#import "DDVideoListVC.h"
#import "DDProductExampleVC.h"
#import "DDMessageModel.h"
#import "DDWalletVC.h"
#import "DDOrderDetailVc.h"
#import "DDMessageDetailVc.h"
#import "DDContactListVC.h"
#import "DDBannerModel.h"
#import "ExampleViewController.h"
#import "STIdentityDetailVC.h"
#import "STAdvertorialsCell.h"
#import "STAdvertorialsDetailVC.h"
#import "STAdvertorialsModel.h"

@interface FYSTHomeVc ()
<UITableViewDelegate,
UITableViewDataSource,
FYSTBannerCellDelegate> {
    NSArray * _footPrints;//软文数据
    NSArray * _products;//板块数据
    NSArray * _messages;//公告数据
    NSArray * _banners;//广告图数据
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) FYSTHomeUserView * userIconView;//导航左边按钮
@property (nonatomic,strong) FYSTRightItemMenuView * rightMenuView;//导航右边按钮
@property (nonatomic,strong) DDProfileVC * profileVC;//抽屉
@property (nonatomic, strong) UIView *guideBackgroundView;//引导view
@property (nonatomic, strong) UIView *messageguideView;//消息引导view
@property (nonatomic, strong) UIView *plateGuideView;//板块引导view
@property (nonatomic, strong) UIView *identityGuideView;//身份引导view

@end

@implementation FYSTHomeVc
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(@0);
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.userIconView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightMenuView];
    
    self.navigationItem.title = @"";
//    if ([DDUserManager share].isLogged) {
//        [self.view addSubview:self.menuView];
//    }
    
//    [self checkUserInfo:^(BOOL finish) {
//        [self.menuView reloadView];
//    }];
    [[DDAppNetwork share] checkAppVersion:nil isShowAll:NO];
    
    [self getPlateData];
    [self getBannerData];
    
    //注册手势 滑出左边控制器
    __weak typeof(self)weakSelf = self;
    [self cw_registerShowIntractiveWithEdgeGesture:NO transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        if (direction == CWDrawerTransitionFromLeft) {
            [weakSelf pushUserRightButtonDidClick];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""]  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    //获取用户信息
    [[DDUserManager share] getUserInfo:nil];

    self.userIconView.userLb.text = [DDUserManager share].isLogged ?  yyTrimNullText([DDUserManager share].user.nickname) : @"未登录";
    if ([DDUserManager share].isLogged && yyTrimNullText([DDUserManager share].user.userHeadImage).length) {
        [self.userIconView.userView sd_setImageWithURL:[NSURL URLWithString:[DDUserManager share].user.userHeadImage]];
    }else {
        self.userIconView.userView.image = [UIImage imageNamed:[DDUserManager share].userPlaceImage];
    }
    [self getMessageData];
    [self getAdvertorialsLisy];
    
    //重写导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41 / 255.0 green:150 / 255.0 blue:235 /255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:41 / 255.0 green:150 / 255.0 blue:235 /255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : UIColorHex(0x193750),
                                                                      }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:true];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
//    self.navigationController.navigationBar.shadowImage = nil;
    //恢复导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""]  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : UIColorHex(0x193750),
                                                                      }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:true];
}

#pragma mark - CustomMethod
//获取广告数据
- (void)getBannerData{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/uas/banner/queryBannerList?token=%@&publishChannel=1",[DDUserManager share].user.token]
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSArray * dic) {
                       @strongify(self)
                       if (!self) return ;
                       NSMutableArray * dataList = @[].mutableCopy;
                       [self.tableView.mj_footer endRefreshing];
                       [self.tableView.mj_header endRefreshing];
                       if (code == 200) {
                           for (NSDictionary * key in dic) {
                               DDBannerModel * item = [DDBannerModel modelWithJSON:key];
                               [dataList addObject:item];
                           }
                           self->_banners = dataList;
                           [self.tableView reloadData];
                       }
                   }];
}

//获取板块数据
- (void)getPlateData {
    @weakify(self)
    [[DDAppNetwork share] get:YES path:[NSString stringWithFormat:@"/tss/product/listPutawayProduct?token=%@",[DDUserManager share].user.token] body:nil completion:^(NSInteger code,NSString *message,NSArray * data) {
        @strongify(self)
        if (!self) return ;
        if (code == 200) {
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSMutableArray * dataList = @[].mutableCopy;
                for (NSInteger i = 0; i < data.count ; i++) {
                    DDProductObj * productObj = [DDProductObj modelWithJSON:data[i]];
                    [dataList addObject:productObj];
                }
                self->_products = dataList;
            }
            [self.tableView reloadData];
            [self loadMessageGuide];
        }
        
    }];
}

// 获取首页消息
- (void)getMessageData{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/uas/message/getUserMessageList?token=%@&page=1&size=3",[DDUserManager share].user.token]
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSDictionary * dic) {
                       @strongify(self)
                       if (!self) return ;
                       NSMutableArray * dataList = @[].mutableCopy;
                       [self.tableView.mj_footer endRefreshing];
                       [self.tableView.mj_header endRefreshing];
                       if (code == 200) {
                      
                           NSArray * list = dic[@"list"];
                           for (NSDictionary * key in list) {
                               DDMessageModel * item = [DDMessageModel modelWithJSON:key];
                               [item layout];
                               [dataList addObject:item];
                           }
                           self->_messages = dataList;
                           [self.tableView reloadData];
                       }
                   }];
}

//获取软文列表
- (void)getAdvertorialsLisy {
    STHttpRequestManager *manager = [STHttpRequestManager shareManager];
    [manager addParameterWithKey:@"type" withValue:@"1"];
    [manager requestDataWithUrl:[NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort7001,ADVERTORIALSLIST] withType:RequestGet withSuccess:^(NSDictionary * _Nonnull dict) {
        if (dict && [dict[@"code"] integerValue] == 200) {
            NSArray * lists = dict[@"data"][@"list"];
            NSMutableArray * dataList = @[].mutableCopy;
            if (lists && [lists isKindOfClass:[NSArray class]]) {
                for (NSDictionary * dic in lists) {
                    STAdvertorialsModel * model = [STAdvertorialsModel modelWithJSON:dic];
                    [dataList addObject:model];
                }
            }
            self->_footPrints = dataList;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } withFail:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

//加载消息引导view
- (void)loadMessageGuide {
    [STTool checkVersionWithSuccess:^(NSDictionary * _Nonnull dict) {
        if (dict && [dict[@"code"] integerValue] == 200) {
            NSString * version = dict[@"data"][@"vNumber"];
            NSString * downLoadURL =  dict[@"data"][@"vUrl"];
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            if ([app_Version isEqualToString:version] && downLoadURL && ![SRUserDefaults boolForKey:Home_FirstClick] && ([DDUserManager share].isLogged ||
            [DDUserManager share].isVisitorUser)) {
                //和最新的版本一致并且是第一次点击
                [SRUserDefaults setBool:YES forKey:Home_FirstClick];
                [[UIApplication sharedApplication].keyWindow addSubview:self.guideBackgroundView];
                [self.guideBackgroundView addSubview:self.messageguideView];
                [self.messageguideView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.bottom.equalTo(self.guideBackgroundView).offset(0);
                }];
            }
        }
    } withFail:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

//修改图片大小
- (UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - ClickMethod
//点击消息中心
- (void)commentButtonDidClick{
    DDMessageVC * vc = [DDMessageVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//点击选择城市
- (void)chooseCityButtonDidClick{
    
}

//点击左边个人头像
- (void)pushUserRightButtonDidClick{
    @weakify(self)
    [self checkLoginStatus:^(BOOL isLogged) {
        @strongify(self)
        if (isLogged) {
            CWLateralSlideConfiguration * conf =  [CWLateralSlideConfiguration defaultConfiguration];
            conf.distance = kScreenSize.width * 0.8;
            conf.scaleY = 0.8;
            conf.maskAlpha = 0.05;
            [self cw_showDrawerViewController:self.profileVC animationType:CWDrawerAnimationTypeDefault configuration:conf];
        }
    }];
}

//点击消息引导
- (void)messageGuideTap {
    [self.messageguideView removeFromSuperview];
    [self.guideBackgroundView addSubview:self.plateGuideView];
    [self.plateGuideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.guideBackgroundView).offset(0);
    }];
}

//点击板块引导
- (void)plateGuideTap {
    [self.plateGuideView removeFromSuperview];
    [self.guideBackgroundView addSubview:self.identityGuideView];
    [self.identityGuideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.guideBackgroundView).offset(0);
    }];
}

//点击身份引导
- (void)identityGuideTap {
    [self.guideBackgroundView removeFromSuperview];
}

#pragma mark - SystemDelegate

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1 + _footPrints.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        FYSTBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FYSTBannerCellId" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[FYSTBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FYSTBannerCellId"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell refreshWithArray:_banners];
        [cell refreshPlateWithArray:_products];
        [cell refreshMessageWithArray:_messages];
        @weakify(self)
        cell.bannerDidClick = ^(NSInteger index) {
            @strongify(self)
            if (!self) return ;
            DDBannerModel * bannerModel = self->_banners[index];
            DDWebVC  * webvcx = [DDWebVC new];
            webvcx.url = bannerModel.url;
            webvcx.title = bannerModel.title;
            webvcx.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webvcx animated:YES];
        };
        return cell;
    }else {
        STAdvertorialsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[STAdvertorialsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        STAdvertorialsModel *model = _footPrints[indexPath.row - 1];
        [cell refreshWithModel:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return 540;
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        STAdvertorialsDetailVC *vc = [[STAdvertorialsDetailVC alloc] init];
        STAdvertorialsModel *model = _footPrints[indexPath.row - 1];
        vc.model = model;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - CustomDelegate

#pragma mark - FYSTBannerCellDelegate
//点击功能
- (void)clickFunction:(NSInteger)index {
    if (index == 100) {
        //代理方
        STIdentityDetailVC *vc = [[STIdentityDetailVC alloc] init];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 101) {
        //实施方
        STIdentityDetailVC *vc = [[STIdentityDetailVC alloc] init];
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 200) {
        //实施步骤
        DDWebVC * vc = [DDWebVC new];
        vc.title = @"实施步骤";
        vc.hidesBottomBarWhenPushed = YES;
        vc.url = [NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort8003,@"/dd-bss/supervisor/manager/onLineFlowDetail"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 201) {
        //演示视频
        ExampleViewController * vc = [ExampleViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 202) {
        //成功案例
        DDProductExampleVC * vc = [DDProductExampleVC new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        //板块
        DDProductDetailVC * vc = [DDProductDetailVC new];
        vc.item = _products[index];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//点击公告消息
- (void)clickMessage:(NSInteger)index {
    DDMessageVC * vc = [DDMessageVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GetterAndSetter
- (FYSTRightItemMenuView *)rightMenuView{
    if (!_rightMenuView) {
        _rightMenuView = [[[NSBundle mainBundle] loadNibNamed:@"FYSTRightItemMenuView" owner:nil options:nil] lastObject];
        @weakify(self)
        _rightMenuView.fystMenuButtonDidClick = ^(NSInteger index) {
            @strongify(self)
            if (index == 1) {
                [self commentButtonDidClick];
            }else {
                [self chooseCityButtonDidClick];
            }
        };
    }
    return _rightMenuView;
}

- (FYSTHomeUserView *)userIconView{
    if (!_userIconView) {
        _userIconView = [[[NSBundle mainBundle] loadNibNamed:@"FYSTHomeUserView" owner:nil options:nil] lastObject];
        @weakify(self)
        _userIconView.fystMenuButtonDidClick = ^(NSInteger index) {
            @strongify(self)
            [self pushUserRightButtonDidClick];
        };
    }
    return _userIconView;
}

- (DDProfileVC *)profileVC {
    if (_profileVC == nil) {
        _profileVC = [DDProfileVC new];
    }
    return _profileVC;
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FYSTBannerCell class] forCellReuseIdentifier:@"FYSTBannerCellId"];
        [_tableView registerClass:[STAdvertorialsCell class] forCellReuseIdentifier:@"cell"];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            if (!self) return ;
            [self getAdvertorialsLisy];
        }];
    }
    return _tableView;
}

- (UIView *)guideBackgroundView {
    if (!_guideBackgroundView) {
        _guideBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _guideBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _guideBackgroundView.userInteractionEnabled = YES;
    }
    return _guideBackgroundView;
}

- (UIView *)messageguideView {
    if (!_messageguideView) {
        _messageguideView = [[UIView alloc] init];
        _messageguideView.userInteractionEnabled = YES;
        
        UIImageView *imageViewOne = [[UIImageView alloc] init];
        imageViewOne.image = [UIImage imageNamed:@"Home_MessageGuide1"];
        [_messageguideView addSubview:imageViewOne];
        [imageViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageguideView).offset(0);
            make.width.equalTo(@(59));
            make.top.equalTo(self.messageguideView).offset(26);
            make.height.equalTo(@(33));
        }];
        
        UIImageView *imageViewTwo = [[UIImageView alloc] init];
        imageViewTwo.image = [UIImage imageNamed:@"Home_MessageGuide2"];
        [_messageguideView addSubview:imageViewTwo];
        [imageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageguideView).offset(-30);
            make.width.equalTo(@(195));
            make.top.mas_equalTo(imageViewOne.mas_bottom).offset(5);
            make.height.equalTo(@(162));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageGuideTap)];
        [_messageguideView addGestureRecognizer:tap];
    }
    return _messageguideView;
}

- (UIView *)plateGuideView {
    if (!_plateGuideView) {
        _plateGuideView = [[UIView alloc] init];
        _plateGuideView.userInteractionEnabled = YES;
        
        UIImageView *imageViewOne = [[UIImageView alloc] init];
        imageViewOne.image = [UIImage imageNamed:@"Home_PlateGuide1"];
        [_plateGuideView addSubview:imageViewOne];
        [imageViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_plateGuideView).offset(10);
            make.width.equalTo(@(18));
            make.top.equalTo(_plateGuideView).offset(NavigationHeight + 210 - 20 + 5);
            make.height.equalTo(@(17));
        }];
        
        CGFloat buttonWidth = (kScreenWidth - 20) / _products.count;
        for (NSInteger i = 0; i < _products.count; i++) {
            DDProductObj * obj = _products[i];
            UIButton *plateButton = [[UIButton alloc] init];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:obj.backImg] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                UIImage *targetImage = [self originImage:image scaleToSize:CGSizeMake(66, 66)];
                [plateButton setImage:targetImage forState:UIControlStateNormal];
            }];
            [plateButton setTitle:obj.productName forState:UIControlStateNormal];
            [plateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            plateButton.titleLabel.font = [UIFont systemFontOfSize:12];
            [plateButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:2];
            [_plateGuideView addSubview:plateButton];
            [plateButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_plateGuideView).offset(10 + (buttonWidth * i));
                make.width.equalTo(@(buttonWidth));
                make.top.equalTo(_plateGuideView).offset(NavigationHeight + 210 - 20 + 15);
                make.height.equalTo(@(85));
            }];
        }
        
        UIImageView *imageViewTwo = [[UIImageView alloc] init];
        imageViewTwo.image = [UIImage imageNamed:@"Home_PlateGuide2"];
        [_plateGuideView addSubview:imageViewTwo];
        [imageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_plateGuideView).offset(-10);
            make.width.equalTo(@(26));
            make.top.equalTo(_plateGuideView).offset(NavigationHeight + 210 - 20);
            make.height.equalTo(@(26));
        }];
        
        UIImageView *imageViewThree = [[UIImageView alloc] init];
        imageViewThree.image = [UIImage imageNamed:@"Home_PlateGuide3"];
        [_plateGuideView addSubview:imageViewThree];
        [imageViewThree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_plateGuideView).offset(10);
            make.right.equalTo(_plateGuideView).offset(-10);
            make.top.equalTo(_plateGuideView).offset(NavigationHeight + 210 - 20 + 15 + 85 + 10);
            make.height.equalTo(@(170));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(plateGuideTap)];
        [_plateGuideView addGestureRecognizer:tap];
    }
    return _plateGuideView;
}

- (UIView *)identityGuideView {
    if (!_identityGuideView) {
        _identityGuideView = [[UIView alloc] init];
        _identityGuideView.userInteractionEnabled = YES;
        
        UIImageView *imageViewOne = [[UIImageView alloc] init];
        imageViewOne.image = [UIImage imageNamed:@"Home_IdentityGuide1"];
        [_identityGuideView addSubview:imageViewOne];
        [imageViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_identityGuideView).offset(10);
            make.right.equalTo(_identityGuideView).offset(-10);
            make.top.equalTo(_identityGuideView).offset(NavigationHeight + 210 - 20 + 85 + 20 + 30 + 20 + 20);
            make.height.equalTo(@(60));
        }];
        
        UIImageView *imageViewTwo = [[UIImageView alloc] init];
        imageViewTwo.image = [UIImage imageNamed:@"Home_IdentityGuide2"];
        [_identityGuideView addSubview:imageViewTwo];
        [imageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageViewOne.mas_left);
            make.right.mas_equalTo(imageViewOne.mas_right);
            make.top.mas_equalTo(imageViewOne.mas_bottom).offset(10);
            make.height.equalTo(@(170));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(identityGuideTap)];
        [_identityGuideView addGestureRecognizer:tap];
    }
    return _identityGuideView;
}

@end
