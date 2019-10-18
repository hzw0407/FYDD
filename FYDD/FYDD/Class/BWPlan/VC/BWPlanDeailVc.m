//
//  BWPlanDeailVc.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "BWPlanDeailVc.h"
#import "BWPlanDetailCell.h"
#import <MJRefresh/MJRefresh.h>
#import "BWPlanModel.h"
#import "DDOrderDetailVc.h"

@interface BWPlanDeailVc () <UITableViewDataSource,UITableViewDelegate> {
    BWPlanModel * _planModel;
}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation BWPlanDeailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百万计划详情";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(@00);
    }];
    [self getPlanDetailData];
}

// 获取计划详情
- (void)getPlanDetailData{
    NSString * urlPath = @"/million/plan/detail";
    NSString * url = [NSString stringWithFormat:@"%@%@",DDAPP_2T_URL,urlPath];
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                          url:url
                   parameters:@{@"id" : _planId,
                                @"token" : [DDUserManager share].user.token,
                                }
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           self->_planModel = [BWPlanModel modelWithJSON:data];
                           [self.tableView reloadData];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                       
                   }];

}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"BWPlanDetailCell" bundle:nil] forCellReuseIdentifier:@"BWPlanDetailCellId"];
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BWPlanDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BWPlanDetailCellId"];
    cell.planModel = _planModel;
    @weakify(self)
    cell.orderDidClick = ^{
        @strongify(self)
        DDOrderDetailVc * vc = [DDOrderDetailVc new];
        vc.orderId = self->_planModel.orderNumber;
        vc.title = @"订单详情";
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 700;
}

@end
