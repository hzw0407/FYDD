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

@interface STIdentityDetailVC ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation STIdentityDetailVC
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.type == 1 ? @"代理方主页" : @"实施方主页";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view).offset(0);
    }];
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
        return 40;
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
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 20)];
        headerLabel.text = @"软文列表";
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.font = [UIFont systemFontOfSize:14];
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
        return 135;
    }else {
        return 110;
    }
}

#pragma mark - CustomDelegate

#pragma mark - GetterAndSetter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
