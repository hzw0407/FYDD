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
#import "FYSTNoticeCell.h"
#import "FYSTFootprintCell.h"
#import "FYSTHomeUserView.h"
#import "FYSTRightItemMenuView.h"
#import "DDMessageVC.h"
#import <CWLateralSlide/UIViewController+CWLateralSlide.h>
#import "DDProfileVC.h"
#import "DDClerkMenuView.h"
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
@interface FYSTHomeVc ()
<UITableViewDelegate,
UITableViewDataSource> {
    NSArray * _footPrints;
    NSArray * _products;
    NSArray * _messages;
    NSArray * _banners;
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) FYSTHomeUserView * userIconView;
@property (nonatomic,strong) FYSTRightItemMenuView * rightMenuView;
@property (nonatomic,strong) DDProfileVC * profileVC;
@property (nonatomic,strong) DDClerkMenuView * menuView;
@end

@implementation FYSTHomeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(@0);
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.userIconView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightMenuView];
    
    self.navigationItem.title = @"";
    if ([DDUserManager share].isLogged) {
        [self.view addSubview:self.menuView];
    }
    [self getFootStrpts];
    
    [self checkUserInfo:^(BOOL finish) {
        [self.menuView reloadView];
    }];
    [[DDAppNetwork share] checkAppVersion:nil isShowAll:NO];
    
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
        }
        
    }];
    
    [self getBannerData];
}

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""]  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [[DDUserManager share] getUserInfo:nil];
    
    self.userIconView.userLb.text = [DDUserManager share].isLogged ?  yyTrimNullText([DDUserManager share].user.nickname) : @"未登录";
    if ([DDUserManager share].isLogged && yyTrimNullText([DDUserManager share].user.userHeadImage).length) {
        [self.userIconView.userView sd_setImageWithURL:[NSURL URLWithString:[DDUserManager share].user.userHeadImage]];
    }else {
        self.userIconView.userView.image = [UIImage imageNamed:[DDUserManager share].userPlaceImage];
    }
    [self.menuView reloadView];
    [self getMessageData];
    [self getFootStrpts];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)getFootStrpts{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                          url:@"http://47.107.166.105:8004/footprint/inexPageList"
                   parameters:@{@"page" : @(1) , @"size" : @(20),@"token":
                                    yyTrimNullText([DDUserManager share].user.token)}
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if(!self) return ;
                       if (code == 200 ){
                           NSArray * lists = data[@"list"];
                           NSMutableArray * dataList = @[].mutableCopy;
                           if (lists && [lists isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in lists) {
                                   DDFootstripObj * footprintModel = [DDFootstripObj modelWithJSON:dic];
                                   [dataList addObject:footprintModel];
                               }
                           }
                           self->_footPrints = dataList;
                           [self.tableView reloadData];
                           [self.tableView.mj_header endRefreshing];
                       }
    }];
}

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

- (DDClerkMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[[NSBundle mainBundle] loadNibNamed:@"DDClerkMenuView" owner:nil options:nil] lastObject];
        _menuView.size = CGSizeMake(50, 100);
        _menuView.left = kScreenSize.width - 65;
        _menuView.top = kScreenSize.height - (iPhoneXAfter ? 49 : 49) - 115;
        @weakify(self)
        _menuView.clertButtonClick = ^(NSInteger index) {
            @strongify(self)
            if (index == 1) {
                DDAuthenVc  * vc = [DDAuthenVc new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                DDOrderVC * vc = [DDOrderVC new];
                vc.hidesBottomBarWhenPushed = YES;
                vc.title = @"订单";
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
    }
    return _menuView;
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

- (void)commentButtonDidClick{
    DDMessageVC * vc = [DDMessageVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chooseCityButtonDidClick{
    
}

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


- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"FYSTBannerCell" bundle:nil] forCellReuseIdentifier:@"FYSTBannerCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"FYSTNoticeCell" bundle:nil] forCellReuseIdentifier:@"FYSTNoticeCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"FYSTFootprintCell" bundle:nil] forCellReuseIdentifier:@"FYSTFootprintCellId"];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            if (!self) return ;
            [self getFootStrpts];
        }];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2 + _footPrints.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        FYSTBannerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FYSTBannerCellId"];
        cell.banners = _banners;
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
    }else  if (indexPath.row == 1){
        FYSTNoticeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FYSTNoticeCellId"];
        cell.productObjs = _products;
        cell.messages = _messages;
        
        @weakify(self)
        cell.messageBlock = ^(NSInteger type) {
            @strongify(self)
            if (!self) return ;
            [self commentButtonDidClick];
            /*
            DDMessageModel * item = self->_messages[indexPath.row -1];
            NSString * jumpURL = item.requestUrl;
            if (jumpURL && [jumpURL rangeOfString:@"fy3tzz://sante/wallet"].location != NSNotFound) {
                DDWalletVC * vc = [DDWalletVC new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (jumpURL && [jumpURL rangeOfString:@"fy3tzz://sante/orderDetail?orderID="].location != NSNotFound) {
                DDOrderDetailVc * vc = [DDOrderDetailVc new];
                vc.title = @"订单详情";
                vc.hidesBottomBarWhenPushed = YES;
                vc.orderId = [jumpURL stringByReplacingOccurrencesOfString:@"fy3tzz://sante/orderDetail?orderID=" withString:@""];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ( jumpURL && [jumpURL rangeOfString:@"fy3tzz://sante/service"].location != NSNotFound){
                DDContactListVC * vc = [DDContactListVC new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (jumpURL && [jumpURL rangeOfString:@"itunes"].location != NSNotFound) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:jumpURL]];
            }else {
                if ([item.messageContent rangeOfString:@"</"].location != NSNotFound) {
                    DDWebVC * vc = [DDWebVC new];
                    vc.title = @"消息详情";
                    vc.htmlText = item.messageContent;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    DDMessageDetailVc * vc = [DDMessageDetailVc new];
                    vc.messageText = item.messageContent;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            if (item.state == 0) {
                item.state = 1;
                @weakify(self)
                [[DDAppNetwork share] get:YES path:[NSString stringWithFormat:@"/uas/message/updateReadMessage?id=%@",item.messageId]
                                     body:@""
                               completion:^(NSInteger code,
                                            NSString *message,
                                            id data) {
                                   @strongify(self)
                                   if (!self) return ;
                                   [self.tableView reloadData];
                                   NSLog(@"%@",message);
                               }];
                
            }
             */
        };
        
        cell.itemBlock = ^(NSInteger type) {
            @strongify(self)
            if (!self) return ;
            DDProductDetailVC * vc = [DDProductDetailVC new];
            vc.item = self->_products[type];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        void (^extractedExpr)(NSInteger) = ^(NSInteger type) {
            @strongify(self)
            
            
            if (type == 0) {
                DDWebVC * vc = [DDWebVC new];
                vc.title = @"上线流程";
                vc.hidesBottomBarWhenPushed = YES;
                vc.url = [NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort8003,@"/dd-bss/supervisor/manager/onLineFlowDetail"];
                [self.navigationController pushViewController:vc animated:YES];
            }else if (type == 1) {
                ExampleViewController * vc = [ExampleViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (type == 2) {
                DDProductExampleVC * vc = [DDProductExampleVC new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        cell.moduleBlock = extractedExpr;
        return cell;
    }else {
        FYSTFootprintCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FYSTFootprintCellId"];
        cell.footprintModel = _footPrints[indexPath.row - 2];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return 276;
    if (indexPath.row == 1) return 305;
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 1) {
        DDTradeDetailVc * vc = [DDTradeDetailVc new];
        DDFootstripObj * footprint = _footPrints[indexPath.row - 2];
        vc.title = footprint.title;
        vc.footstripObj = footprint;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
