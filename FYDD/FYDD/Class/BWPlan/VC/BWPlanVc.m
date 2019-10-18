//
//  BWPlanVc.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "BWPlanVc.h"
#import "BWPlanCell.h"
#import "BWPlanDeailVc.h"
#import "BWPlanAddVc.h"
#import <MJRefresh.h>
#import "BWPlanModel.h"
#import "DDAuthenticationIdCardVcView.h"

@interface BWPlanVc () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    NSString * _status;
    NSMutableDictionary * _pageDict;
    NSMutableDictionary * _dataDicts;
    NSString * _searchText;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *statusLineView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic)  UIButton *tempButton;
@end

@implementation BWPlanVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _tempButton = _allButton;
    self.navigationItem.title = @"";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self leftTitleLb]];
    [self.tableView registerNib:[UINib nibWithNibName:@"BWPlanCell" bundle:nil] forCellReuseIdentifier:@"BWPlanCellId"];
    
    // 推广员
    _status = @"";
    _pageDict = @{}.mutableCopy;
    _dataDicts = @{}.mutableCopy;
    @weakify(self)
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        if (!self) return ;
        NSInteger page = [self getCurrentPage];
        page ++;
        [self updateCurrentPage:page];
        [self getBWPlanData:page];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (!self) return ;
        [self updateCurrentPage:0];
        [self getBWPlanData:0];
    }];
    self.searchBar.delegate = self;
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([DDUserManager share].user.userType == DDUserTypePromoter) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add_t"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonDidClick)];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""]  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _searchText = searchText;
    [self updateCurrentPage:0];
    [self getBWPlanData:0];
}

- (NSInteger)getCurrentPage{
    id pageObj = [_pageDict objectForKey:@(_tempButton.tag)];
    if (!pageObj) return 0;
    return [pageObj integerValue];
}

- (void)updateCurrentPage:(NSInteger)page{
    [_pageDict setObject:@(page) forKey:@(_tempButton.tag)];
}

- (void)updateDataList:(NSArray *)dataList{
    [_dataDicts setObject:dataList forKey:@(_tempButton.tag)];
}

- (NSArray *)getDataList{
    NSArray * dataList = [_dataDicts objectForKey:@(_tempButton.tag)];
    if (!dataList) dataList = @[];
    return dataList;
}

// 获取百万计划数据
- (void)getBWPlanData:(NSInteger)page{
    NSString * urlPath = @"/million/plan/userOnline/list";
    if ([DDUserManager share].user.userType == DDUserTypePromoter) {
        urlPath = @"/million/plan/userExtension/list";
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",DDAPP_2T_URL,urlPath];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                          url:url
                   parameters:@{@"page" : @(page),
                                @"size" : @(20),
                                @"token" : [DDUserManager share].user.token,
                                @"customerStatus" : _status,
                                @"companyName" : yyTrimNullText(_searchText)
                                }
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       [self.tableView.mj_header endRefreshing];
                       if (code == 200) {
                           NSArray * list  = data[@"list"];
                           NSMutableArray * dataList = @[].mutableCopy;
                           if (list && list.count) {
                               for (NSDictionary * dic in list) {
                                   BWPlanModel * planModel = [BWPlanModel modelWithJSON:dic];
                                   [dataList addObject:planModel];
                               }
                               if (page != 0 && [self getDataList].count) {
                                   [dataList addObjectsFromArray:[self getDataList]];
                               }
                           }
                           [self updateDataList:dataList];
                           if (list.count < 20) {
                               [self.tableView.mj_footer endRefreshingWithNoMoreData];
                           }else {
                               [self.tableView.mj_footer resetNoMoreData];
                           }
                           [self.tableView reloadData];
                       }else {
                           [self updateDataList:@[]];
                           [self.tableView reloadData];
                           [DDHub hub:message view:self.view];
                       }
    }];
}

- (void)rightButtonDidClick{
    [self checkLoginStatus:^(BOOL isLogged) {
        if (isLogged) {
            if ([DDUserManager share].user.realAuthentication != 1) {
                DDAuthenticationIdCardVcView * vc = [DDAuthenticationIdCardVcView new];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [DDHub hub:@"未实名认证，请先认证" view:vc.view];
                });
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            BWPlanAddVc * vc = [BWPlanAddVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (UILabel * )leftTitleLb{
    UILabel * lab = [UILabel new];
    lab.text = @"百万计划";
    lab.font = [UIFont systemFontOfSize:24];
    lab.textColor = UIColorHex(0x131313);
    lab.bounds = CGRectMake(0, 0, 100, 44);
    return lab;
}



- (IBAction)statusButtonDidClick:(UIButton *)sender {
    if (_tempButton != sender) {
        _tempButton.selected = NO;
        sender.selected = YES;
        _tempButton = sender;
        @weakify(self)
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            @strongify(self)
            if (sender.tag == 0) {
                self.statusLineView.left =34;
            }else if (sender.tag == 2) {
                self.statusLineView.left = kScreenSize.width - 80;
            }else {
                self.statusLineView.centerX = kScreenSize.width * 0.5;
            }
        } completion:^(BOOL finished) {
            
        }];
    }
    _status = @"";
    if (sender.tag == 1) {
        _status = @"1";
    }else if (sender.tag == 2) {
        _status = @"2";
    }
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self getDataList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BWPlanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BWPlanCellId"];
    cell.planModel = [self getDataList][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BWPlanModel * planModel = [self getDataList][indexPath.row];
    BWPlanDeailVc * vc = [BWPlanDeailVc new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.planId = planModel.planId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
