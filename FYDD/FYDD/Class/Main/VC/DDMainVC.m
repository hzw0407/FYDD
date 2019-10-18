//
//  DDMainVC.m
//  FYDD
//
//  Created by mac on 2019/2/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDMainVC.h"
#import "DDMessageVC.h"
#import "DDProfileVC.h"

#import "DDLocationView.h"
#import "DDBannerCell.h"
#import "DDMainMenuCell.h"
#import "DDMainTipCell.h"
#import "DDProductItem.h"
#import "DDProductCell.h"
#import "DDProductDetailVC.h"
#import "DDOrderVC.h"
#import <CWLateralSlide/UIViewController+CWLateralSlide.h>
#import <MJRefresh/MJRefresh.h>
#import "DDWebVC.h"
#import "DDVideoListVC.h"
#import "DDProductExampleVC.h"
#import "DDBannerTopModel.h"
#import "DDWebVC.h"
#import "DDEditUserVC.h"
#import "DDLoginVC.h"
#import "DDCityListVC.h"
#import "SRLocationTool.h"
#import "SRUserDefaults.h"
#import "DDWalletVC.h"
#import "OrderDetailVC.h"
#import "DDContactListVC.h"

@interface DDMainVC ()<UITableViewDelegate,UITableViewDataSource,SRLocationToolDelegate> {
    NSArray <DDProductItem*>* _datas;
    NSInteger _currentPage;
    NSArray <DDBannerTopModel *>* _banners;
    NSString * _currentCity;
}
@property (nonatomic,strong) DDLocationView * locationView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) DDProfileVC * profileVC;
@end

@implementation DDMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

    _currentPage = 0;
    [self getBannerListData];
    [self.tableView.mj_header beginRefreshing];
    

    [self checkUserInfo:^(BOOL finish) {
        
    }];
    [[DDAppNetwork share] checkAppVersion:^{
        
    } isShowAll:NO];

}

- (void)beginLocation {
    [SRLocationTool sharedInstance].delegate = self;
    if ([SRUserDefaults boolForKey:kHasRequestLocationAuthorization]) {
        if ([SRLocationTool sharedInstance].isAutoLocation) {
            [[SRLocationTool sharedInstance] beginLocation];
            NSString *city = [SRLocationTool sharedInstance].currentLocationCity;
            NSLog(@"%@",city);
            _currentCity = city;
        }
    } else {
        [SRUserDefaults setBool:YES forKey:kHasRequestLocationAuthorization];
        [[SRLocationTool sharedInstance] requestAuthorization];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self beginLocation];
    // 更新地址
    if ([DDUserManager share].isLogged) {
        @weakify(self)
        [[DDUserManager share] getUserInfo:^{
            @strongify(self)

            
            if (yyTrimNullText([DDUserManager share].user.area).length > 0){
                [self.locationView.nameLb setTitle:yyTrimNullText([DDUserManager share].user.area) forState:UIControlStateNormal];
            }else {
                [self.locationView.nameLb setTitle:@"深圳市" forState:UIControlStateNormal];
            }
        }];
    }else {
        [self.locationView.nameLb setTitle:@"深圳市" forState:UIControlStateNormal];
    }
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage =nil;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)gotoMessageVc:(NSString *)url{
    
    NSString * jumpURL = url;
    if (jumpURL && [jumpURL rangeOfString:@"fy3tzz://sante/wallet"].location != NSNotFound) {
        DDWalletVC * vc = [DDWalletVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (jumpURL && [jumpURL rangeOfString:@"fy3tzz://sante/orderDetail?orderID="].location != NSNotFound) {
        OrderDetailVC * vc = [OrderDetailVC new];
        vc.title = @"订单详情";
        vc.orderId = [jumpURL stringByReplacingOccurrencesOfString:@"fy3tzz://sante/orderDetail?orderID=" withString:@""];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ( jumpURL && [jumpURL rangeOfString:@"fy3tzz://sante/service"].location != NSNotFound){
        DDContactListVC * vc = [DDContactListVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (jumpURL && [jumpURL rangeOfString:@"itunes"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:jumpURL]];
    }else {
        DDMessageVC * vc = [DDMessageVC  new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getProductDataRequst{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/tss/product/listPutawayProduct?page=%d",1]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           NSMutableArray * dataLists = @[].mutableCopy;
                           if (data && [data isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in (NSArray *)data){
                                   DDProductItem * item = [DDProductItem modelWithJSON:dic];
                                   [item layout];
                                   [dataLists addObject:item];
                               }
                           }
                           self->_datas = dataLists;
                           [self.tableView reloadData];
                       }
                       [self.tableView.mj_footer endRefreshing];
                       [self.tableView.mj_header endRefreshing];
                   }];
}

- (void)getBannerListData{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/uas/banner/queryBannerList?page=%d&publishChannel=1",1]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           NSMutableArray * dataLists = @[].mutableCopy;
                           if (data && [data isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in (NSArray *)data){
                                   DDBannerTopModel * item = [DDBannerTopModel modelWithJSON:dic];
                                   [dataLists addObject:item];
                               }
                           }
                           self->_banners = dataLists;
                           [self.tableView reloadData];
                       }
                       [self.tableView.mj_footer endRefreshing];
                       [self.tableView.mj_header endRefreshing];
                   }];
}

#pragma mark - UI
- (DDProfileVC *)profileVC {
    if (_profileVC == nil) {
        _profileVC = [DDProfileVC new];
    }
    return _profileVC;
}

- (void)setupUI{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_mess"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonDidClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_profile"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonDidClick)];

    self.navigationItem.titleView = self.locationView;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 11.2){
        [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@200);
            make.height.mas_equalTo(@44);
        }];
    }else {
        _locationView.frame = CGRectMake(0, 0, 250, 44);
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
}

-(DDLocationView *)locationView {
    if (!_locationView) {
        _locationView = [[[NSBundle mainBundle] loadNibNamed:@"DDLocationView" owner:nil options:nil] lastObject];
        _locationView.autoresizingMask = UIViewAutoresizingNone;
        @weakify(self)
        _locationView.event = ^{
            @strongify(self)
            if (!self) return ;
            DDCityListVC * vc = [DDCityListVC new];
            vc.city = self->_currentCity;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]
                               animated:YES completion:^{
                
            }];
        };
    }
    return _locationView;
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DDBannerCell class] forCellReuseIdentifier:@"DDBannerCellId"];
        [_tableView registerClass:[DDMainMenuCell class] forCellReuseIdentifier:@"DDMainMenuCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDMainTipCell" bundle:nil] forCellReuseIdentifier:@"DDMainTipCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDProductCell" bundle:nil] forCellReuseIdentifier:@"DDProductCellId"];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            if (!self) return ;
            [self getProductDataRequst];
        }];
    }
    return _tableView;
}


#pragma mark - event
- (void)rightButtonDidClick{
    @weakify(self)
    [self checkLoginStatus:^(BOOL isLogged) {
        @strongify(self)
        if (isLogged) {
            DDMessageVC * vc = [DDMessageVC  new];
            [self.navigationController pushViewController:vc animated:true];
        }
    }];
}

- (void)leftButtonDidClick{
    @weakify(self)
    [self checkLoginStatus:^(BOOL isLogged) {
        @strongify(self)
        if (isLogged) {
            CWLateralSlideConfiguration * conf =  [CWLateralSlideConfiguration defaultConfiguration];
            conf.distance = kScreenSize.width * 0.5;
            [self cw_showDrawerViewController:self.profileVC animationType:CWDrawerAnimationTypeDefault configuration:conf];
        }
    }];
}


- (void)menuDidClick:(NSInteger)type{
    DDUserType userType = [DDUserManager share].user.userType;
    // 上线流程
    if ((type == 0 && userType == DDUserTypeSystem  && [DDUserManager share].isLogged ) ||
        (type == 1 && userType != DDUserTypeSystem  && [DDUserManager share].isLogged ) ||
        (type == 0 && ![DDUserManager share].isLogged)
        ) {
        DDWebVC * vc = [DDWebVC new];
        vc.title = @"上线流程";
        vc.url = [NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort8003,@"/dd-bss/supervisor/manager/onLineFlowDetail"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    // 演示视屏
    if ((type == 1 && userType == DDUserTypeSystem && [DDUserManager share].isLogged ) ||
        (type == 2 && userType != DDUserTypeSystem && [DDUserManager share].isLogged)||
        (type == 1 && ![DDUserManager share].isLogged)
        ) {
        DDVideoListVC * vc = [DDVideoListVC new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    // 成功案例
    if ((type == 2 && userType == DDUserTypeSystem  && [DDUserManager share].isLogged ) ||
        (type == 3 && userType != DDUserTypeSystem  && [DDUserManager share].isLogged )||
        (type == 2 && ![DDUserManager share].isLogged)
        ) {
        DDProductExampleVC * vc = [DDProductExampleVC new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    // 订单
    if ((userType == DDUserTypeOnline) && type == 0) {
        DDOrderVC * vc = [DDOrderVC new];
        vc.title = @"实施方";
        [self.navigationController pushViewController:vc animated:YES];
         return;
    }
    if ((userType == DDUserTypePromoter) && type == 0) {
        DDOrderVC * vc = [DDOrderVC new];
        vc.title = @"代理方";
        [self.navigationController pushViewController:vc animated:YES];
         return;
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3 + _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.row == 0) {
        DDBannerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDBannerCellId"];
        cell.banners = _banners;
        cell.event = ^(NSInteger index) {
            @strongify(self)
            if (!self) return ;
            if (index < self->_banners.count) {
                DDBannerTopModel * item = self->_banners[index];
                DDWebVC * webVc = [DDWebVC new];
                webVc.url = item.url;
                webVc.title = @"详情";
                [self.navigationController pushViewController:webVc animated:YES];
            }
            
        };
        return cell;
    }else if (indexPath.row ==1){
        DDMainMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDMainMenuCellId"];
        @weakify(self)
        cell.event = ^(NSInteger index) {
            [weak_self menuDidClick:index];
        };
        if ([DDUserManager share].isLogged) {
            switch ([DDUserManager share].user.userType) {
                case DDUserTypeOnline:
                    [cell setMenuDatas:@[@{@"icon" : @"icon_menu1" , @"text" : @"实施方入口"},
                                         @{@"icon" : @"icon_menu3" , @"text" : @"上线流程"},
                                         @{@"icon" : @"icon_menu4" , @"text" : @"演示视频"},
                                         @{@"icon" : @"icon_menu5" , @"text" : @"成功案例"}]];
                    break;
                case DDUserTypeSystem:
                    [cell setMenuDatas:@[
                                         @{@"icon" : @"icon_menu3" , @"text" : @"上线流程"},
                                         @{@"icon" : @"icon_menu4" , @"text" : @"演示视频"},
                                         @{@"icon" : @"icon_menu5" , @"text" : @"成功案例"}]];
                    break;
                case DDUserTypePromoter:
                    [cell setMenuDatas:@[
                                         @{@"icon" : @"icon_menu2" , @"text" : @"代理方入口"},
                                         @{@"icon" : @"icon_menu3" , @"text" : @"上线流程"},
                                         @{@"icon" : @"icon_menu4" , @"text" : @"演示视频"},
                                         @{@"icon" : @"icon_menu5" , @"text" : @"成功案例"}]];
                    break;
                    
                default:
                    break;
            }
        }else {
            [cell setMenuDatas:@[
                                 @{@"icon" : @"icon_menu3" , @"text" : @"上线流程"},
                                 @{@"icon" : @"icon_menu4" , @"text" : @"演示视频"},
                                 @{@"icon" : @"icon_menu5" , @"text" : @"成功案例"}]];
        }

        

        return cell;
    }else if (indexPath.row == 2){
        DDMainTipCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDMainTipCellId"];
        return  cell;
    }else  {
        DDProductCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDProductCellId"];
        cell.item = _datas[indexPath.row - 3];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ){
        return  (kScreenSize.width / 375.0) * 180 + 1;
    }else if (indexPath.row == 1) {
        return 100;
    }else if (indexPath.row == 2) {
        return 40;
    }
    return _datas[indexPath.row - 3].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 2) {
//        DDProductDetailVC * vc = [DDProductDetailVC new];
//        vc.item = _datas[indexPath.row - 3];
//        [self.navigationController pushViewController:vc animated:true];
    }
}

@end
