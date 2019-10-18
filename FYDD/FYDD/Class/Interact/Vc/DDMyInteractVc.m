//
//  DDMyInteractVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDMyInteractVc.h"
#import "BWPlanDeailVc.h"
#import "BWPlanAddVc.h"
#import "DDOpportunityDetailVc.h"
#import "DDTraceCell.h"
#import <MJRefresh/MJRefresh.h>
#import "DDFootstripObj.h"
#import "DDAddTraceVc.h"
#import "DDTradeDetailVc.h"
#import "DDInteractCell.h"
#import "DDInteractObj.h"
#import "DDInteractDetailVc.h"
#import "DDInteractAddView.h"
#import "DDAddInteractVc.h"
#import "DDMyInteractVc.h"

@interface DDMyInteractVc ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    NSInteger _currentPage;
    NSMutableArray * _dataList;
    NSString * _searchText;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *footPlaceLb;
@end

@implementation DDMyInteractVc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的互助";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _searchBar.delegate = self;
    self->_dataList  = @[].mutableCopy;
    [self.tableView registerNib:[UINib nibWithNibName:@"DDInteractCell" bundle:nil] forCellReuseIdentifier:@"DDInteractCellId"];
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self->_currentPage = 1;
        [self getMyFootprint];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self->_currentPage += 1;
        [self getMyFootprint];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _currentPage = 1;
    [self getMyFootprint];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _searchText = searchText;
     _currentPage = 1;
    [self getMyFootprint];
}

- (void)getMyFootprint{
    @weakify(self)
    [DDHub hub:self.view];
    NSString * url = [NSString stringWithFormat:@"%@/helpEachOther/list?token=%@&size=20&page=%zd&isPublic=1&title=%@",DDAPP_2T_URL,[DDUserManager share].user.token,_currentPage,[yyTrimNullText(_searchText) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ];
    [[DDAppNetwork share] get:YES
                          url:url
                   parameters:nil
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       [self.tableView.mj_header endRefreshing];
                       [self.tableView.mj_footer endRefreshing];
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           NSArray * lists = data[@"list"];
                           NSMutableArray * datas = @[].mutableCopy;
                           if (lists && [lists isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in lists) {
                                   DDInteractObj * obj = [DDInteractObj modelWithJSON:dic];
                                   [datas addObject:obj];
                               }
                           }
                           self.footPlaceLb.hidden = datas.count != 0;
                           if (datas.count < 20) {
                               [self.tableView.mj_footer endRefreshingWithNoMoreData];
                           }else {
                               [self.tableView.mj_footer resetNoMoreData];
                           }
                           if (self->_currentPage > 1 && datas.count) {
                               [self->_dataList addObjectsFromArray:datas];
                           }else {
                               self->_dataList = datas;
                           }
                           [self.tableView reloadData];
                           
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDInteractCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDInteractCellId"];
    cell.interactObj = _dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDInteractDetailVc * vc = [DDInteractDetailVc new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.footstripObj = _dataList[indexPath.row];
    vc.title = @"互助详情";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
