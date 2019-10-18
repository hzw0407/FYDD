//
//  DDWalletVC.m
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDWalletVC.h"
#import "DDWalletTopCell.h"
#import "DDWalletMoneyCell.h"
#import "DDRechargeVC.h"
#import "DDGetMoneyToBank.h"
#import "DDWalletModel.h"
#import <MJRefresh/MJRefresh.h>
#import "DDAlertView.h"
#import "DDAlertView.h"
#import "DDPayPasswordVC.h"
#import "DDwalletDetailVc.h"

@interface DDWalletVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableDictionary * _pageDict;;
    NSMutableDictionary * _dataDict;
    NSInteger _currentType;
    double _balance;
    double _amountFrozen;
    DDWalletTopCell * _topCell;
}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱包";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    _balance = 0;
    _pageDict = @{}.mutableCopy;
    _dataDict = @{}.mutableCopy;
}

- (void)setupNavigationBar{
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [DDAppManager share].appTintColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:true];
}


- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorHex(0xefefef);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDWalletTopCell" bundle:nil] forCellReuseIdentifier:@"DDWalletTopCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDWalletMoneyCell" bundle:nil] forCellReuseIdentifier:@"DDWalletMoneyCellId"];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            if (!self) return ;
            [self getWalletList];
            [self getWalletMoney];
            [self->_pageDict setObject:@(1) forKey:@(self->_currentType)];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            if (!self) return ;
            NSInteger page = 1;
            if (self->_pageDict[@(self->_currentType)]) {
                page = [self->_pageDict[@(self->_currentType)] integerValue];
            }
            page = page + 1;
            [self->_pageDict setObject:@(page) forKey:@(self->_currentType)];
            [self getWalletList];
        }];
    }
    return _tableView;
}

- (void)topMenuView:(NSInteger)type{
    // 充值
    if (type == 3) {
        DDRechargeVC * vc = [DDRechargeVC new];
        [self.navigationController pushViewController:vc animated:true];
    // tixian
    }else if (type == 4) {
        @weakify(self)
        [DDHub hub:self.view];
        [[DDUserManager share] getUserPayPasswordStateCompletion:^(BOOL suc) {
            @strongify(self)
            if (!self) return ;
            // 判断是否这是支付密码
            [DDHub dismiss:self.view];
            if (!suc) {
                [DDAlertView showTitle:@"温馨提示"
                              subTitle:@"您未设置支付密码！"
                           actionName1:@"去设置"
                           actionName2:@"取消" sureEvent:^{
                               DDPayPasswordVC * vc = [DDPayPasswordVC new];
                               [self.navigationController pushViewController:vc animated:YES];
                           } cancelEvent:^{
                               
                           }];
            }else {
                
                DDGetMoneyToBank * vc = [DDGetMoneyToBank new];
                vc.banlance = self->_balance;
                [self.navigationController pushViewController:vc animated:true];
            }
        }];
    }else {
        _currentType = type;
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getWalletMoney];
    [self getWalletList];
    [self getWalletMoney];
    [self->_pageDict setObject:@(1) forKey:@(self->_currentType)];
    [self setupNavigationBar];
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



// 获取钱包余额
- (void)getWalletMoney{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/fps/wallet/wallet/getUserBalance?token=", [DDUserManager share].user.token)
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200){
                           self->_balance = [data[@"amountFrozen"] doubleValue] + [data[@"balance"] doubleValue];
                           self->_amountFrozen = [data[@"balance"] doubleValue];
                           [self.tableView reloadData];
                       }
                   }];
}

// 获取钱包明细
-(void)getWalletList{
    NSInteger page = [_pageDict[@(self->_currentType)] integerValue];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/fps/wallet/record/getWalletRecordList?token=%@&pageNum=%zd&walletType=%zd",[DDUserManager share].user.token,page,_currentType + 1]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       [self.tableView.mj_header endRefreshing];
                       [self.tableView.mj_footer endRefreshing];
                       if (code == 200) {
                           NSMutableArray * dataList = @[].mutableCopy;
                           NSMutableArray * cacheList = self->_dataDict[@(self->_currentType)];
                           NSInteger page = [self->_pageDict[@(self->_currentType)] integerValue];
                           if (page != 1) {
                               if (cacheList && cacheList.count > 0) {
                                   [dataList addObjectsFromArray:cacheList];
                               }
                           }
                           
                           NSArray * requstList = data[@"list"];
                           if ([requstList isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in requstList) {
                                   DDWalletModel * model = [DDWalletModel modelWithJSON:dic];
                                   [dataList addObject:model];
                               }
                           }
                           [self->_dataDict setObject:dataList forKey:@(self->_currentType)];
                           [self.tableView reloadData];
                           NSInteger total  = [data[@"total"] integerValue];
                           if (total <= dataList.count) {
                           }
                       }
                       
                   }];
}

- (NSArray *)getDataList{
    NSArray * dataList =  _dataDict[@(_currentType)];
    if (!dataList ){
        dataList = @[];
    }
    return dataList;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1 + [self getDataList].count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        @weakify(self)
        DDWalletTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDWalletTopCellId"];
        if (!_topCell) {
            _topCell = cell;
        }else {
            cell = _topCell;
        }
        cell.event = ^(NSInteger index) {
            [weak_self topMenuView:index];
        };
        if(_amountFrozen > 10000){
            cell.shenyuLb.text = [NSString stringWithFormat:@"¥%.f",_amountFrozen];
        }else {
            cell.shenyuLb.text = [NSString stringWithFormat:@"¥%.2f",_amountFrozen];
        }
        if(_balance > 10000){
            cell.moneyLb.text = [NSString stringWithFormat:@"¥%.f",_balance];
        }else {
            cell.moneyLb.text = [NSString stringWithFormat:@"¥%.2f",_balance];
        }
        return cell;
    }else {
        DDWalletMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDWalletMoneyCellId"];
        cell.item = [self getDataList][indexPath.row - 1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) return 313;
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0 ) {
        DDwalletDetailVc * vc = [DDwalletDetailVc  new];
        DDWalletModel * item = [self getDataList][indexPath.row - 1];
        vc.payId = item.walletId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
