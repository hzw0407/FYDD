//
//  DDOpportunityDetailVc.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOpportunityDetailVc.h"
#import "DDOpportunityDetailCell.h"
#import "BWPlanDetailCell.h"
#import <MJRefresh/MJRefresh.h>
#import "BRDatePickerView.h"
#import "DDOrderDetailVc.h"

@interface DDOpportunityDetailVc ()<UITableViewDataSource,UITableViewDelegate>{
    DDOpportunityModel * _opportunityModel;
}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDOpportunityDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商机详情";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(@00);
    }];
    [self getOpportunityModel];
}

- (void)getOpportunityModel{
    [DDHub hub:self.view];
    NSString * url = [NSString stringWithFormat:@"%@/business/detail?token=%@",DDAPP_2T_URL,[DDUserManager share].user.token];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                          url:url
                   parameters:@{@"id" : _detailId}
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200){
                           [DDHub dismiss:self.view];
                           self->_opportunityModel = [DDOpportunityModel modelWithJSON:data];
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
        [_tableView registerNib:[UINib nibWithNibName:@"DDOpportunityDetailCell" bundle:nil] forCellReuseIdentifier:@"DDOpportunityDetailCellId"];
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
    DDOpportunityDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOpportunityDetailCellId"];
    cell.appModel = _opportunityModel;
    @weakify(self)
    cell.renlinBlock = ^{
        @strongify(self)
        [self renLinButtonDidClick:self->_opportunityModel];
    };
    cell.orderBtnBlock = ^{
        @strongify(self)
        DDOrderDetailVc  * vc = [DDOrderDetailVc new];
        vc.orderId  = self->_opportunityModel.orderNumber;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 700;
}

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
                                                              [self.tableView.mj_header beginRefreshing];
                                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                  DDOrderDetailVc  * vc = [DDOrderDetailVc new];
                                                                  vc.orderId  = self->_opportunityModel.orderNumber;
                                                                  vc.hidesBottomBarWhenPushed = YES;
                                                                  [self.navigationController pushViewController:vc animated:YES];
                                                              });
                                                          }else {
                                                              [DDHub hub:message view:self.view];
                                                          }
                                                      }];
                                   }];
    
    
}

@end
