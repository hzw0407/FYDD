//
//  DDJuniorVC.m
//  FYDD
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDJuniorVC.h"
#import "DDHistoryMoneyCell.h"
#import "DDMoneyTopCell.h"
#import "DDJuniorRowCell.h"
#import "DDCloumCell.h"
#import <FSCalendar/FSCalendar.h>
#import "BRDatePickerView.h"
#import "DDJuniorModel.h"
#import <FSCalendar/FSCalendar.h>
#import "NSDate+BRPickerView.h"
#import <YYKit/YYKit.h>
#import "DDJuniorBarView.h"

@interface DDJuniorVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString  * _dateText;
    NSString  * _dateText1;
    NSArray * _dataLists;

    
    NSInteger orderCountMoneys;
    NSInteger orderCounts;
    NSInteger total;
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) DDJuniorBarView * barView;
@end

@implementation DDJuniorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下线";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.barView];
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@44);
        make.bottom.mas_equalTo(iPhoneXAfter? @(-30) : @(0));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.mas_equalTo(iPhoneXAfter? @(-74) : @(-44));
    }];
    
    
    _dateText = @"";
    _dateText1 = @"";
    [self getJuniorRequst];
}


- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDJuniorRowCell" bundle:nil] forCellReuseIdentifier:@"DDJuniorRowCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDMoneyTopCell" bundle:nil] forCellReuseIdentifier:@"DDMoneyTopCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDCloumCell" bundle:nil] forCellReuseIdentifier:@"DDCloumCellId"];

    }
    return _tableView;
}

- (DDJuniorBarView *)barView{
    if (!_barView) {
        _barView = [[[NSBundle mainBundle] loadNibNamed:@"DDJuniorBarView" owner:nil options:nil] lastObject];
    }
    return _barView;
}

// 获取下线员
- (void)getJuniorRequst{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/tss/orders/extensionOfflineOrder?token=%@&endDate=%@&startDate=%@",[DDUserManager share].user.token,_dateText1,_dateText]
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSDictionary * data) {
                       @strongify(self)
                       if (!self) return ;
                       [DDHub dismiss:self.view];
                       self->_dataLists = @[].mutableCopy;
                       if (code == 200) {
                           NSArray * datacounts = data[@"list"];
                           NSMutableArray * dataList = @[].mutableCopy;
                           self->orderCountMoneys = [[NSString stringWithFormat:@"%@",data[@"orderCountMoneys"]] integerValue];
                           self->orderCounts = [[NSString stringWithFormat:@"%@",data[@"orderCounts"]] integerValue];
                           if ([datacounts isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in datacounts) {
                                    DDJuniorModel * item = [DDJuniorModel modelWithJSON:dic];
                                   [dataList addObject:item];
                               }
                               self->_dataLists = dataList;
                           }
                           self.barView.nameLB1.text = [NSString stringWithFormat:@"%zd名",self->_dataLists.count];
                           self.barView.nameLb2.text = [NSString stringWithFormat:@"%zd笔",self->orderCounts];
                           self.barView.nameLb3.text = [NSString stringWithFormat:@"¥%zd",self->orderCountMoneys];
                       }
                       [self.tableView reloadData];
                   }];
    
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/uas/user/extension/extensionOfflineNum?token=%@",[DDUserManager share].user.token]
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSDictionary * data) {
                       @strongify(self)
                       if (!self) return ;
                       [DDHub dismiss:self.view];
                       if (code == 200) {
                           self->total = [[NSString stringWithFormat:@"%@",data] integerValue];
                       }
                       [self.tableView reloadData];
                   }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1 + _dataLists.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DDMoneyTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDMoneyTopCellId"];
        [cell.startBtn setTitle:_dateText.length == 0 ? @"开始时间" : _dateText forState:UIControlStateNormal];
        [cell.endBtn setTitle:_dateText1.length == 0 ? @"结束时间" : _dateText1 forState:UIControlStateNormal];
        cell.totalLb.text = [NSString stringWithFormat:@"下线总数人数: %zd 名",total];
        @weakify(self)
        cell.event = ^(NSInteger index) {
            @strongify(self)
            if (!self)return ;
            if (index == 0 || index == 1) {
                [self startDate:index];
            }else {
                if (self->_dateText.length == 0) {
                    [DDHub hub:@"请选择开始时间" view:self.view];
                    [self startDate:0];
                    return;
                }
                if (self->_dateText1.length == 0) {
                    [self startDate:1];
                    [DDHub hub:@"请选择结束时间" view:self.view];
                    return;
                }
                [self getJuniorRequst];
            }
 
        };
        return cell;
    }else{
        DDJuniorRowCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDJuniorRowCellId"];
        cell.model = _dataLists[indexPath.row -1];
        cell.textLb1.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        return cell;
    }
}

- (void)startDate:(NSInteger)index{
    [BRDatePickerView showDatePickerWithTitle:index == 0 ? @"开始时间" : @"结束时间"
                                     dateType:BRDatePickerModeYM
                              defaultSelValue:@""
                                      minDate:[NSDate dateWithTimeIntervalSince1970:1554091920]
                                      maxDate:nil
                                 isAutoSelect:NO
                                   themeColor:nil
                                  resultBlock:^(NSString *selectValue) {
                                      if (index == 0) {
                                          self->_dateText = selectValue;
                                      }else {
                                          self->_dateText1 = selectValue;
                                      }
                                      [self.tableView reloadData];
                                  }];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return 85;
    return 60;
}

@end
