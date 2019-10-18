//
//  DDOpportunityVc.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOpportunityVc.h"
#import "DDOpportunityCell.h"
#import "BWPlanDeailVc.h"
#import "BWPlanAddVc.h"
#import "DDOpportunityDetailVc.h"
#import <MJRefresh/MJRefresh.h>
#import "BRDatePickerView.h"
#import "DDOrderDetailVc.h"

@interface DDOpportunityVc () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    NSInteger _opportunityPage;
    NSMutableArray * _dataList;
    NSString * _searchText;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DDOpportunityVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _opportunityPage = 0;
    self.navigationItem.title = @"";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self leftTitleLb]];
    [self.tableView registerNib:[UINib nibWithNibName:@"DDOpportunityCell" bundle:nil] forCellReuseIdentifier:@"DDOpportunityCellId"];
    _dataList = @[].mutableCopy;
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (!self) return ;
        self->_opportunityPage = 0;
        [self getOpportunityData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        if (!self) return ;
        self->_opportunityPage += 1;
        [self getOpportunityData];
    }];
    self.searchBar.delegate = self;
    [self.tableView.mj_header beginRefreshing];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchText = searchText;
    [self getOpportunityData];
}

- (void)getOpportunityData{
    NSString * url = [NSString stringWithFormat:@"%@/business/userOnline/list",DDAPP_2T_URL];
    if ([DDUserManager share].user.userType == DDUserTypePromoter) {
        url = [NSString stringWithFormat:@"%@/business/userExtension/list",DDAPP_2T_URL];
    }
    
    @weakify(self)
    [[DDAppNetwork share] get:YES
                          url:url
                   parameters:@{@"page" : @(self->_opportunityPage),
                                @"size" : @(20),
                                @"token" : [DDUserManager share].user.token,
                                @"companyName" : [yyTrimNullText(_searchText) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ,
                                }
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       [self.tableView.mj_header endRefreshing];
                       if (code == 200) {
                           NSArray *lists = data[@"list"];
                           NSMutableArray * dataLists  = @[].mutableCopy;
                           if (lists && lists.count > 0) {
                               if (self->_opportunityPage == 0 && self->_dataList.count > 0) {
                                   [dataLists addObjectsFromArray:self->_dataList];
                               }
                               for (NSDictionary * dic in lists) {
                                   DDOpportunityModel * model = [DDOpportunityModel modelWithJSON:dic];
                                   [dataLists addObject:model];
                               }
                           }
                           self->_dataList = dataLists;
                           if (lists.count < 20) {
                               [self.tableView.mj_footer endRefreshingWithNoMoreData];
                           }else {
                               [self.tableView.mj_footer resetNoMoreData];
                           }
                       }else {
                           
                       }
                       [self.tableView reloadData];
                   }];

}

- (void)rightButtonDidClick{
    BWPlanAddVc * vc = [BWPlanAddVc new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UILabel * )leftTitleLb{
    UILabel * lab = [UILabel new];
    lab.text = @"商机";
    lab.font = [UIFont systemFontOfSize:24];
    lab.textColor = UIColorHex(0x131313);
    lab.bounds = CGRectMake(0, 0, 100, 44);
    return lab;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""]  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    _opportunityPage = 0;
    [self getOpportunityData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDOpportunityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOpportunityCellId"];
    cell.model = _dataList[indexPath.row];
    @weakify(self)
    cell.renLinBlock = ^{
      @strongify(self)
      if (!self) return ;
        [self renLinButtonDidClick:self->_dataList[indexPath.row]];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 260;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDOpportunityDetailVc * vc = [DDOpportunityDetailVc new];
    vc.hidesBottomBarWhenPushed = YES;
    DDOpportunityModel * oppModel = _dataList[indexPath.row];
    vc.detailId = oppModel.planId;
    [self.navigationController pushViewController:vc animated:YES];
}

// 认领
- (void)renLinButtonDidClick:(DDOpportunityModel *)opportunity{
    @weakify(self)
    [BRDatePickerView showDatePickerWithTitle:@"选择服务开始时间"
                                     dateType:BRDatePickerModeYMD
                              defaultSelValue:@""
                                      minDate:[NSDate date] maxDate:nil
                                 isAutoSelect:NO
                                   themeColor:nil resultBlock:^(NSString *selectValue) {
                                       @strongify(self)
                                       NSString * url = [NSString stringWithFormat:@"%@/business/userOnline/claim?token=%@",DDAPP_2T_URL,[DDUserManager share].user.token];
                                       if ([DDUserManager share].user.userType == DDUserTypePromoter) {
                                           url = [NSString stringWithFormat:@"%@/business/userExtension/claim?token=%@",DDAPP_2T_URL,[DDUserManager share].user.token];
                                       }
                                       [DDHub hub:self.view];
                                       NSDictionary * dic = @{@"id" : opportunity.planId , @"busType" : [DDUserManager share].user.userType == DDUserTypePromoter ? @(1) : @(2),@"dateStr" : selectValue};
                                       [[DDAppNetwork share] get:NO
                                                             url:url
                                                            body:[dic modelToJSONString]
                                                      completion:^(NSInteger code,
                                                                   NSString *message,
                                                                   id data) {
                                                          @strongify(self)
                                                          if(!self) return ;
                                                          if (code == 200) {
                                                              [DDHub hub:@"认领成功" view:self.view];
                                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                  DDOrderDetailVc  * vc = [DDOrderDetailVc new];
                                                                  vc.orderId  = opportunity.orderNumber;
                                                                  vc.hidesBottomBarWhenPushed = YES;
                                                                  [self.navigationController pushViewController:vc animated:YES];
                                                              });
                                                              [self.tableView.mj_header beginRefreshing];
                                                          }else {
                                                              [DDHub hub:message view:self.view];
                                                          }
                                                      }];
                                   }];
    
    
}


@end
