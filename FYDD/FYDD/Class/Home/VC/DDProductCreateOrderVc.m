//
//  DDProductCreateOrderVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/7.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProductCreateOrderVc.h"
#import "DDProductOrderOnlineCell.h"
#import "DDOrderPromptCell.h"
#import "DDProductOrderPortCell.h"
#import "DDProductOrderInfoCell.h"
#import <Masonry/Masonry.h>
#import "DDOnlineModel.h"
#import "DDProductNextOrderVc.h"

@interface DDProductCreateOrderVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDProductCreateOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下单页";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(@0);
    }];
    _detailObj.isSystemOnline = YES;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDProductOrderOnlineCell" bundle:nil] forCellReuseIdentifier:@"DDProductOrderOnlineCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDOrderPromptCell" bundle:nil] forCellReuseIdentifier:@"DDOrderPromptCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDProductOrderPortCell" bundle:nil] forCellReuseIdentifier:@"DDProductOrderPortCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDProductOrderInfoCell" bundle:nil] forCellReuseIdentifier:@"DDProductOrderInfoCellId"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DDProductOrderInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDProductOrderInfoCellId"];
        cell.nameLB.text = _detailObj.productName;
        if (_isFree) {
            cell.dayLb.text = [NSString stringWithFormat:@"%zd天",_detailObj.testUseTime];
        }else {
            cell.dayLb.text = @"永久";
        }
        cell.clipsToBounds = YES;
        return cell;
    }else if (indexPath.row == 1) {
        DDProductOrderPortCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDProductOrderPortCellId"];
        cell.detailObj = _detailObj;
        return cell;
    }else if (indexPath.row == 2) {
        DDOrderPromptCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderPromptCellId"];
        cell.promptNameLb.text = yyTrimNullText(_detailObj.extensionUserName);
        cell.promptContactLb.text = yyTrimNullText(_detailObj.extensionPhone);
        return cell;
    }else if (indexPath.row == 3) {
        DDProductOrderOnlineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDProductOrderOnlineCellId"];
        cell.obj = _detailObj;
        @weakify(self)
        cell.onlineSeachBarBlock = ^(NSString * _Nonnull searchText) {
            @strongify(self)
            [self searchOnlineUser:searchText];
        };
        cell.onlineBlock = ^(NSInteger type) {
            @strongify(self)
            if (type == 1) {
                [self createOrder];
            }
        };
        return cell;
    }
    return nil;
}

- (void)createOrder{
    NSDictionary * dic = @{@"productId" : @(_detailObj.objId),
                           @"packageId" : _detailObj.port.portId,
                           @"implementationMember" : _detailObj.isSystemOnline ? @"" : @(_detailObj.onlineModel.onlineId)
                           };
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:[NSString stringWithFormat:@"/tss/orders/toSubmitOrder?token=%@",[DDUserManager share].user.token]
                         body:[dic modelToJSONString]
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           DDProductNextOrderVc * vc = [DDProductNextOrderVc new];
                           vc.orderNumber = data[@"orderNumber"];
                           [self.navigationController pushViewController:vc animated:YES];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];

}

- (void)searchOnlineUser:(NSString *)searchTexr{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/uas/user/online/getUserOnlineByPhone?phone=", searchTexr)
                         body:@""
                   completion:^(NSInteger code, NSString *message,id data) {
                       @strongify(self)
                       if(!self) return ;
                       if (code == 200 || code == 2001) {
                           [DDHub dismiss:self.view];
                           self.detailObj.onlineModel = [DDOnlineModel modelWithJSON:data];
                           self.detailObj.isSystemOnline = NO;
                           [self.tableView reloadData];
                       }else {
                           self.detailObj.onlineModel = nil;
                           [DDHub hub:@"未搜到实施方" view:self.view];
                           [self.tableView reloadData];
                       }
                   }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return _isFree ? 80 : 50;
    }
    if (indexPath.row == 1) {
        return 392;
    }
    if (indexPath.row == 2) {
        return 80;
    }
    if (indexPath.row == 3) {
        return 385;
    }
    return 0;
}

@end
