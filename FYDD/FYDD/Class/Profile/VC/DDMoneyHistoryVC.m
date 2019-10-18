//
//  DDMoneyHistoryVC.m
//  FYDD
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDMoneyHistoryVC.h"
#import "DDHistoryMoneyCell.h"
#import "DDMoneyTopCell.h"
#import "BRDatePickerView.h"
#import <MJRefresh/MJRefresh.h>
#import "DDBankModelHistoryModel.h"
#import <FSCalendar/FSCalendar.h>
#import "NSDate+BRPickerView.h"
#import <YYKit/YYKit.h>
#import "DDwalletDetailVc.h"
#import "DDMoneyTopDateCell.H"

@interface DDMoneyHistoryVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString * _date;
    NSString * _lastDay;
    NSInteger _currentPage;
    NSArray <DDBankModelHistoryModel*>* _dataList;
}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDMoneyHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现记录";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    _date = [formatter stringFromDate:[NSDate date]];
    [self.tableView.mj_header beginRefreshing];
    _dataList = @[];
}



- (void)getJuniorRequst{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    
    NSInteger day =  [NSDate br_getDaysInYear:[[NSDate date] year] month:[[NSDate date] month]];
    _lastDay = [NSString stringWithFormat:@"%@-%zd",_date,day];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/fps/wallet/record/wallet/getExtractCashList?token=%@&date=%@&page=%zd",[DDUserManager share].user.token,_date,_currentPage]
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSDictionary * data) {
                       @strongify(self)
                       if (!self) return ;
                       [self.tableView.mj_header endRefreshing];
                       [self.tableView.mj_footer endRefreshing];
                       NSMutableArray * dataList = @[].mutableCopy;
                       if (self->_currentPage == 1) {
                           self->_dataList = @[];
                       }else {
                           if (self->_dataList.count > 0) {
                               [dataList addObjectsFromArray:self->_dataList];
                           }
                       }
                       if (code == 200) {
                           NSInteger total = [data[@"total"] integerValue];
                           NSArray * list = data[@"list"];
                           for (NSDictionary * dic in list) {
                               DDBankModelHistoryModel * item = [DDBankModelHistoryModel modelWithJSON:dic];
                               [item layout];
                               [dataList addObject:item];
                           }
                           self->_dataList = dataList;
                           if (total == self->_dataList.count) {
                               [self.tableView.mj_footer endRefreshingWithNoMoreData];
                           }
                       }
                        [self.tableView reloadData];
                   }];
}


- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDHistoryMoneyCell" bundle:nil] forCellReuseIdentifier:@"DDHistoryMoneyCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDMoneyTopDateCell" bundle:nil] forCellReuseIdentifier:@"DDMoneyTopDateCellId"];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            if (!self) return ;
            self->_currentPage = 1;
            [self getJuniorRequst];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            if (!self) return ;
            self->_currentPage += 1;
            [self getJuniorRequst];
        }];
    }
    return _tableView;
}

- (void)topMenuView{
    @weakify(self)
    [BRDatePickerView showDatePickerWithTitle:@"选择时间"
                                     dateType:BRDatePickerModeYM
                              defaultSelValue:@""
                                  resultBlock:^(NSString *selectValue) {
                                      @strongify(self)
                                      if (!self)return ;
                                      self->_date = selectValue;
                                      self->_currentPage = 1;
                                      [self.tableView.mj_header beginRefreshing];
                                  }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.row == 0) {
        DDMoneyTopDateCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDMoneyTopDateCellId"];
        [cell.btn setTitle:_date forState:UIControlStateNormal];
        cell.timeLb.text = [NSString stringWithFormat:@"统计时间: %@-01 - %@",_date,_lastDay];
        cell.event = ^(NSInteger index){
            @strongify(self)
            [self topMenuView];
        };
        return cell;
    }else {
        DDHistoryMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDHistoryMoneyCellId"];
        cell.item = _dataList[indexPath.row - 1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row  == 0) return;
    DDBankModelHistoryModel * item = _dataList[indexPath.row - 1];
    DDwalletDetailVc * vc = [DDwalletDetailVc new];
    vc.payId = item.moneyId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
