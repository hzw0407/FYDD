//
//  DDOnlineStudyVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/3.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOnlineStudyVc.h"
#import "DDOnlineStudyModel.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import "DDOnlineStudyCell.h"
#import "DDWebContentVc.h"

@interface DDOnlineStudyVc () <UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_onlineDatas;
}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDOnlineStudyVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线学习";
    [self getOnlineStudyData];
    _onlineDatas = @[].mutableCopy;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(@0);
    }];
}

- (void)getOnlineStudyData{
    [DDHub hub:self.view];
    @weakify(self)
    NSString * url = [NSString stringWithFormat:@"%@/exam/learn/online/getAllLearn?identityType=%@",DDAPP_2T_URL, _userType == DDUserTypePromoter ? @"2" : @"1"];
    [[DDAppNetwork share] get:YES
                          url:url
                   parameters:nil
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           for (NSDictionary * dic in (NSArray *)data) {
                               DDOnlineStudyModel * item = [DDOnlineStudyModel modelWithJSON:dic];
                               [self->_onlineDatas addObject:item];
                           }
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
        [_tableView registerNib:[UINib nibWithNibName:@"DDOnlineStudyCell" bundle:nil] forCellReuseIdentifier:@"DDOnlineStudyCellId"];
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _onlineDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDOnlineStudyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOnlineStudyCellId"];
    DDOnlineStudyModel * onlineModel = _onlineDatas[indexPath.row];
    cell.oneLineLb.text = onlineModel.title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDOnlineStudyModel * onlineModel = _onlineDatas[indexPath.row];
    DDWebContentVc * vc = [DDWebContentVc new];
    vc.url = onlineModel.content;
    vc.title = onlineModel.title;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
