//
//  STIdentityDetailVC.m
//  FYDD
//
//  Created by 何志武 on 2019/10/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//  --身份详情

#import "STIdentityDetailVC.h"
#import "STIdentityDetailFunctionCell.h"
#import "STAdvertorialsCell.h"
#import "DDOrderVC.h"
#import "BWPlanVc.h"
#import "DDOpportunityVc.h"

@interface STIdentityDetailVC ()
<UITableViewDelegate,
UITableViewDataSource,
STIdentityDetailFunctionCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation STIdentityDetailVC
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.type == 1 ? @"代理方主页" : @"实施方主页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view).offset(0);
    }];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - CustomMethod

#pragma mark - ClickMethod

#pragma mark - SystemDelegate

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return  1;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //功能
        STIdentityDetailFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[STIdentityDetailFunctionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        [cell refreshDataWithType:self.type];
        return cell;
    }else {
        //软文
        STAdvertorialsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[STAdvertorialsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else {
        return 25;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        return view;
    }else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 5, 15)];
        headerImageView.image = [UIImage imageNamed:@"Home_Line"];
        [headerView addSubview:headerImageView];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 20, 25)];
        headerLabel.text = @"涨知识";
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.font = [UIFont systemFontOfSize:18];
        [headerView addSubview:headerLabel];
        return headerView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 205;
    }else {
        return 110;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
     if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
         [cell setLayoutMargins:UIEdgeInsetsZero];
     }
}

#pragma mark - CustomDelegate

#pragma mark - STIdentityDetailFunctionCellDelegate
//点击某个功能
- (void)clickIndex:(NSInteger)index {
    if (index == 1) {
        if (self.type == 1) {
            //代理流程
        }else {
            //实施流程
        }
    }else if (index == 2) {
        //我的订单
        DDOrderVC * vc = [[DDOrderVC alloc] init];
        if (self.type == 1) {
            vc.type = 2;
        }else {
            vc.type = 3;
        }
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"订单";
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        //我的客户
        if (self.type == 1) {
            //之前的百万计划
            BWPlanVc *vc = [[BWPlanVc alloc] init];
            vc.title = @"我的客户";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            //之前的商机
            DDOpportunityVc *vc = [[DDOpportunityVc alloc] init];
            vc.title = @"我的客户";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - GetterAndSetter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
