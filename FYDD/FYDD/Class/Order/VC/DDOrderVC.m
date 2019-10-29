//
//  DDClerkVC.m
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderVC.h"
#import "DDClerkOrderCell.h"
#import "OrderDetailVC.h"
#import <MJRefresh.h>
#import "DDOrderTopView.h"
#import "DDOrderInfo.h"
#import "DDOrderPayVC.h"
#import <UIImageView+WebCache.h>
#import "DDOrderDetailVc.h"
#import "DDOrderCarryView.h"
#import "DDOrderCompanyInfoView.h"
#import "DDProductNextOrderVc.h"
#import "DDJuniorVC.h"

@interface DDOrderVC ()<UITableViewDelegate,UITableViewDataSource> {
    NSInteger _currentType;
//    NSMutableDictionary* _pageDict;
    NSMutableDictionary * _datas;
    DDOrderCheckUser * _user;
    DDOrderExtensionUser * _extensionUser;
}

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) DDOrderCarryView * carryView;
@property (nonatomic,strong) DDOrderCompanyInfoView * companyView;

@end

@implementation DDOrderVC
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = UIColorHex(0xF3F4F6);
    
    if (self.type == 2 || self.type == 3) {
        //代理方、实施方
        [self.view addSubview:self.carryView];
        [self.carryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(@0);
            make.height.mas_equalTo(@230);
        }];
    }else if (self.type == 1) {
        //企业用户
        [self.view addSubview:self.companyView];
        [self.companyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(@0);
            make.height.mas_equalTo(@230);
        }];
    }
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
         make.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.top.mas_equalTo(@230);
    }];
    
    _currentType = 1;
//    _pageDict = @{}.mutableCopy;
    _datas = @{}.mutableCopy;
    
    if (self.type == 2) {
        //代理方
        [self getExtensionInfo];
    }else if (self.type == 3) {
        //实施方
        [self getOnlineInfo];
    }
    
    [self destructionRed];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBar];
//    self->_pageDict[@(self->_currentType)] = @(1);
    [self getOrderListData];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [DDAppManager share].navigationTintColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                        NSForegroundColorAttributeName : UIColorHex(0x193750),
                                                                      }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:true];
}

#pragma mark - CustomMethod
- (void)setupNavigationBar{
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [DDAppManager share].appTintColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:true];
}

//销毁订单红点
- (void)destructionRed {
    STHttpRequestManager *manager = [STHttpRequestManager shareManager];
    [manager addParameterWithKey:@"token" withValue:[DDUserManager share].user.token];
    [manager addParameterWithKey:@"type" withValue:@"1"];
    [manager addParameterWithKey:@"change" withValue:@"order"];
    [manager requestDataWithUrl:[NSString stringWithFormat:@"%@:%@//fps/wallet/getHavChange",DDAPP_URL,DDPort7001] withType:RequestGet withSuccess:^(NSDictionary * _Nonnull dict) {
        if (dict && [dict[@"code"] integerValue] == 200) {
            
        }
    } withFail:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [DDHub hub:error.domain view:self.view];
    }];
}

//获取订单列表数据
- (void)getOrderListData{
//    id pageObject = _pageDict[@(_currentType)];
//    if (!pageObject) {
//        pageObject = @(1);
//    }
    @weakify(self)
    NSInteger userType;
    if (self.type == 1) {
        userType = 1;
    }else if (self.type == 2) {
        userType = 3;
    }else {
        userType = 2;
    }
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/tss/orders/findOrderByType?token=%@&state=%@&userType=%zd", [DDUserManager share].user.token,@(_currentType),userType]
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSDictionary * data) {
                       @strongify(self)
                       if (!self) return ;
//                       [self.tableView.mj_header endRefreshing];
//                       [self.tableView.mj_footer endRefreshing];
                       NSMutableArray * datas = @[].mutableCopy;
//                       if ([pageObject integerValue] != 1) {
//                           NSArray * cacheList = self->_datas[@(self->_currentType)];
//                           if (cacheList) {
//                               datas = [NSMutableArray arrayWithArray:cacheList];
//                           }
//                       }
                       if (code == 200) {
                           NSArray * dataList = data[@"list"];
                           if ([dataList isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in dataList) {
                                   DDOrderInfo * info = [DDOrderInfo modelWithJSON:dic];
                                   [datas addObject:info];
                               }
                           }
                           [self->_datas setObject:datas forKey:@(self->_currentType)];
                           [self.tableView reloadData];
                       }
                   }];
}

//获取代理方头部信息
- (void)getExtensionInfo {
    @weakify(self)
    [[DDAppNetwork share] get:YES
          path:[NSString stringWithFormat:@"/uas/user/extension/getExtensionInOrder?token=%@", [DDUserManager share].user.token]
          body:@""
    completion:^(NSInteger code, NSString *message, NSDictionary * data) {
        @strongify(self)
        if (!self) return ;
        if (code == 200) {
            self->_extensionUser = [DDOrderExtensionUser modelWithJSON:data];
            self.carryView.extensionUser = self->_extensionUser;
        }
    }];
}

//获取实施方头部信息
- (void)getOnlineInfo {
    @weakify(self)
        [[DDAppNetwork share] get:YES
                             path:[NSString stringWithFormat:@"/uas/user/online/getonlineInfoInOrder?token=%@", [DDUserManager share].user.token]
                             body:@""
                       completion:^(NSInteger code, NSString *message, NSDictionary * data) {
                           @strongify(self)
                           if (!self) return ;
                           if (code == 200) {
                               self->_user = [DDOrderCheckUser modelWithJSON:data];
                               self.carryView.checkUser = self->_user;
                           }
                       }];
}

#pragma mark - ClickMethod

#pragma mark - SystemDelegate

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self getDataList].count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDClerkOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDClerkOrderCellId"];
    cell.info = [self getDataList][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DDOrderInfo * info = [self getDataList][indexPath.row];
    if ([info.orderStatus isEqualToString:@"001"]){
        DDProductNextOrderVc * vc = [DDProductNextOrderVc new];
        vc.orderNumber = info.orderNumber;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        DDOrderDetailVc * vc = [DDOrderDetailVc new];
        vc.type = self.type;
        vc.orderId = info.orderNumber;
        vc.title = @"订单详情";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark - CustomDelegate

#pragma mark - GetterAndSetter
- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorHex(0xF3F4F6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDClerkOrderCell" bundle:nil] forCellReuseIdentifier:@"DDClerkOrderCellId"];
//        @weakify(self)
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            @strongify(self)
//            if (!self) return ;
//            self->_pageDict[@(self->_currentType)] = @(1);
//            [self getOrderListData];
//        }];
//        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            @strongify(self)
//            if (!self) return ;
//            id pageObjc = self->_pageDict[@(self->_currentType)];
//            if (!pageObjc) {
//                pageObjc = @(1);
//            }
//            self->_pageDict[@(self->_currentType)] = @([pageObjc integerValue] + 1);
//            [self getOrderListData];
//        }];
    }
    return _tableView;
}


- (DDOrderCarryView *)carryView{
    if (!_carryView) {
        _carryView = [[[NSBundle mainBundle] loadNibNamed:@"DDOrderCarryView" owner:nil options:nil] lastObject];
        @weakify(self)
        _carryView.event = ^(NSInteger index) {
            @strongify(self)
            if (!self) return ;
            if (self.type == 2 && index == 2) {
                //下线
                DDJuniorVC *vc = [[DDJuniorVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                self->_currentType = index + 1;
                [self getOrderListData];
//                [self.tableView reloadData];
//                [self.tableView.mj_header beginRefreshing];
            }
        };
    }
    return _carryView;
}

- (DDOrderCompanyInfoView *)companyView{
    if (!_companyView) {
        _companyView = [[[NSBundle mainBundle] loadNibNamed:@"DDOrderCompanyInfoView" owner:nil options:nil] lastObject];
        @weakify(self)
        _companyView.event = ^(NSInteger index) {
            @strongify(self)
            if (!self) return ;
            self->_currentType = index + 1;
            [self getOrderListData];
//            [self.tableView reloadData];
//            [self.tableView.mj_header beginRefreshing];
        };
    }
    return _companyView;
}


- (NSArray *)getDataList{
    NSArray * cacheList = self->_datas[@(self->_currentType)];
    if (!cacheList) return @[];
    return cacheList;
}

@end
