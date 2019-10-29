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
@property (nonatomic, strong) UIView *balanceBackgroundView;//余额背景view
@property (nonatomic, strong) UIView *cashBackgroundView;//可提现背景view

@end

@implementation DDWalletVC
#pragma mark - lifecycle
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getWalletMoney];
    [self getWalletList];
    [self getWalletMoney];
    [self destructionRed];
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

//销毁钱包红点
- (void)destructionRed {
    STHttpRequestManager *manager = [STHttpRequestManager shareManager];
    [manager addParameterWithKey:@"token" withValue:[DDUserManager share].user.token];
    [manager addParameterWithKey:@"type" withValue:@"1"];
    [manager addParameterWithKey:@"change" withValue:@"wallet"];
    [manager requestDataWithUrl:[NSString stringWithFormat:@"%@:%@//fps/wallet/getHavChange",DDAPP_URL,DDPort7001] withType:RequestGet withSuccess:^(NSDictionary * _Nonnull dict) {
        if (dict && [dict[@"code"] integerValue] == 200) {
            
        }
    } withFail:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [DDHub hub:error.domain view:self.view];
    }];

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

- (void)topMenuView:(NSInteger)type{
    if (type == 3) {
        //充值
        DDRechargeVC * vc = [DDRechargeVC new];
        [self.navigationController pushViewController:vc animated:true];
    }else if (type == 4) {
        //提现
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
    }else if (type == 5) {
        //账户余额提示
        [[UIApplication sharedApplication].keyWindow addSubview:self.balanceBackgroundView];
    }else if (type == 6) {
        //可提现金额提示
        [[UIApplication sharedApplication].keyWindow addSubview:self.cashBackgroundView];
    }else {
        //切换类型
        _currentType = type;
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - ClickMethod
- (void)banlanceTap {
    [self.balanceBackgroundView removeFromSuperview];
}

- (void)cashTap {
    [self.cashBackgroundView removeFromSuperview];
}

#pragma mark - SystemDelegate

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

#pragma mark - CustomDelegate

#pragma mark - GetterAndSetter
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

- (UIView *)balanceBackgroundView {
    if (!_balanceBackgroundView) {
        _balanceBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _balanceBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _balanceBackgroundView.userInteractionEnabled = YES;
        
        UIView *banlanceView = [[UIView alloc] init];
        banlanceView.backgroundColor = [UIColor whiteColor];
        [_balanceBackgroundView addSubview:banlanceView];
        [banlanceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_balanceBackgroundView).offset(20);
            make.right.equalTo(_balanceBackgroundView).offset(-20);
            make.centerY.mas_equalTo(_balanceBackgroundView.mas_centerY);
            make.height.equalTo(@(180));
        }];
        [banlanceView layoutIfNeeded];
        banlanceView.layer.cornerRadius = 10.0;
        
        UILabel *tiplabelOne = [[UILabel alloc] init];
        tiplabelOne.text = @"账户余额";
        tiplabelOne.textColor = [UIColor blackColor];
        tiplabelOne.font = [UIFont systemFontOfSize:15];
        tiplabelOne.textAlignment = NSTextAlignmentCenter;
        [banlanceView addSubview:tiplabelOne];
        [tiplabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(banlanceView).offset(0);
            make.top.equalTo(banlanceView).offset(50);
            make.height.equalTo(@(20));
        }];
        
        UILabel *tipLabelTwo = [[UILabel alloc] init];
        tipLabelTwo.text = @"账户总余额,包括可用的余额以及不可用的余额";
        tipLabelTwo.textColor = [UIColor grayColor];
        tipLabelTwo.font = [UIFont systemFontOfSize:13];
        tipLabelTwo.textAlignment = NSTextAlignmentCenter;
        [banlanceView addSubview:tipLabelTwo];
        [tipLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(banlanceView).offset(0);
            make.bottom.equalTo(banlanceView).offset(-40);
            make.height.equalTo(@(20));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(banlanceTap)];
        [_balanceBackgroundView addGestureRecognizer:tap];
        
    }
    return _balanceBackgroundView;
}

- (UIView *)cashBackgroundView {
    if (!_cashBackgroundView) {
        _cashBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _cashBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _cashBackgroundView.userInteractionEnabled = YES;
        
        UIView *cashView = [[UIView alloc] init];
        cashView.backgroundColor = [UIColor whiteColor];
        [_cashBackgroundView addSubview:cashView];
        [cashView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cashBackgroundView).offset(20);
            make.right.equalTo(_cashBackgroundView).offset(-20);
            make.centerY.mas_equalTo(_cashBackgroundView.mas_centerY);
            make.height.equalTo(@(180));
        }];
        
        UILabel *tipLabelOne = [[UILabel alloc] init];
        tipLabelOne.text = @"可提现余额";
        tipLabelOne.textColor = [UIColor blackColor];
        tipLabelOne.font = [UIFont systemFontOfSize:15];
        tipLabelOne.textAlignment = NSTextAlignmentCenter;
        [cashView addSubview:tipLabelOne];
        [tipLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(cashView).offset(0);
            make.top.equalTo(cashView).offset(50);
            make.height.equalTo(@(20));
        }];
        
        UILabel *tipLabelTwo = [[UILabel alloc] init];
        tipLabelTwo.text = @"可提现以及使用支付余额";
        tipLabelTwo.textColor = [UIColor grayColor];
        tipLabelTwo.font = [UIFont systemFontOfSize:13];
        tipLabelTwo.textAlignment = NSTextAlignmentCenter;
        [cashView addSubview:tipLabelTwo];
        [tipLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(cashView).offset(0);
            make.bottom.equalTo(cashView).offset(-40);
            make.height.equalTo(@(20));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cashTap)];
        [_cashBackgroundView addGestureRecognizer:tap];
    }
    return _cashBackgroundView;
}

@end
