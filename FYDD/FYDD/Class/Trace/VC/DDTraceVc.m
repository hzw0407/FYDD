//
//  DDTraceVc.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDTraceVc.h"
#import "BWPlanDeailVc.h"
#import "BWPlanAddVc.h"
#import "DDOpportunityDetailVc.h"
#import "DDTraceCell.h"
#import <MJRefresh/MJRefresh.h>
#import "DDFootstripObj.h"
#import "DDAddTraceVc.h"
#import "DDTradeDetailVc.h"

@interface DDTraceVc ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    NSInteger _currentPage;
    NSMutableArray * _dataList;
    NSString * _searchBarText;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *footPlaceLb;
@end

@implementation DDTraceVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchBar.delegate = self;
    self.navigationItem.title = @"";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self leftTitleLb]];
    [self.tableView registerNib:[UINib nibWithNibName:@"DDTraceCell" bundle:nil] forCellReuseIdentifier:@"DDTraceCellId"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add_t"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonDidClick)];
    
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (!self) return ;
        self->_currentPage = 1;
        [self getMyFootprint];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        @strongify(self)
        if (!self) return ;
        self->_currentPage += 1;
        [self getMyFootprint];
    }];
    
    self.footPlaceLb.hidden = YES;
    _dataList = @[].mutableCopy;
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _searchBarText = searchText;
    self->_currentPage = 1;
    [self getMyFootprint];
}

- (void)getMyFootprint{
    @weakify(self)
    [DDHub hub:self.view];
    NSString * url = [NSString stringWithFormat:@"%@/footprint/list?token=%@&size=20&page=%zd&title=%@",DDAPP_URL,[DDUserManager share].user.token,_currentPage,[yyTrimNullText(_searchBarText) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ];
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
                                   DDFootstripObj * obj = [DDFootstripObj modelWithJSON:dic];
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

- (void)rightButtonDidClick{
    DDAddTraceVc * vc = [DDAddTraceVc new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UILabel * )leftTitleLb{
    UILabel * lab = [UILabel new];
    lab.text = @"足迹";
    lab.font = [UIFont systemFontOfSize:24];
    lab.textColor = UIColorHex(0x131313);
    lab.bounds = CGRectMake(0, 0, 100, 44);
    return lab;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""]  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDTraceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDTraceCellId"];
    cell.footObj = _dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDTradeDetailVc * vc = [DDTradeDetailVc new];
    vc.isMe = YES;
    vc.footstripObj = _dataList[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
