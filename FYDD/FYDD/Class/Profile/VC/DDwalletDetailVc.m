//
//  DDwalletDetailVc.m
//  FYDD
//
//  Created by mac on 2019/5/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDwalletDetailVc.h"
#import <MJRefresh/MJRefresh.h>
#import "DDBaseCell.h"
@interface DDwalletDetailVc ()<UITableViewDelegate,UITableViewDataSource>{
    NSString * _balance;
    NSString * _amount;
    NSString * _createDate;
    NSString * _type;
    NSString * _rechargeType;
    NSString * _poundage;
    
}

@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDwalletDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易详情";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(@0);
    }];
    
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/fps/wallet/record/getRechargeDetail?token=%@&id=%zd",[DDUserManager share].user.token,_payId]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200){
                           [DDHub dismiss:self.view];
                           self->_balance = [NSString stringWithFormat:@"%.2f",[data[@"balance"] doubleValue]];
                           self->_amount = [NSString stringWithFormat:@"%.2f",[data[@"amount"] doubleValue]];
                           self->_poundage = yyTrimNullText(data[@"poundage"]);
                           NSString * dateString = data[@"createDate"];
                           if ([dateString rangeOfString:@"T"].location != NSNotFound) {
                               dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                               if ([dateString rangeOfString:@"."].location != NSNotFound)  {
                                   NSArray * dateText = [dateString componentsSeparatedByString:@"."];
                                   dateString = dateText[0];
                               }
                           }
                           self->_createDate = dateString;
                           NSInteger type = [yyTrimNullText(data[@"type"]) integerValue];
                           NSInteger rechargeType = [yyTrimNullText(data[@"rechargeType"]) integerValue];
                           if (type == 1) {
                               self->_type = @"充值";
                           }else if (type == 2) {
                               self->_type = @"提现";
                           }else if (type == 3) {
                               self->_type = @"订单支付";
                           }else if (type == 4) {
                               self->_type = @"推广收入";
                           }else if (type == 5) {
                               self->_type = @"上线收入";
                           }else if (type == 6) {
                               self->_type = @"续费支出";
                           }else if (type == 7) {
                               self->_type = @"支付发票";
                           }
                           
                           if (rechargeType == 2) {
                               self->_rechargeType = @"支付宝充值";
                           }else if (rechargeType == 3) {
                               self->_rechargeType = @"微信充值";
                           }else if (rechargeType == 4) {
                               self->_rechargeType = @"线下充值";
                           }
                           [self.tableView reloadData];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorHex(0xefefef);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDUserAvatarCell" bundle:nil] forCellReuseIdentifier:@"DDUserAvatarCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDBaseCell" bundle:nil] forCellReuseIdentifier:@"DDBaseCellId"];
    }
    return _tableView;
}

- (NSArray *)getTitleNames {
    return @[@"交易时间:",
             @"交易前余额:",
             @"交易金额:",
             @"操作类型:",
             @"交易方式",
             @"手续费"];
}

- (NSArray *)getValues{
    return @[yyTrimNullText(_createDate),
             yyTrimNullText(_balance),
             yyTrimNullText(_amount),
             yyTrimNullText(_type),
             yyTrimNullText(_rechargeType),
             yyTrimNullText(_poundage)];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self getTitleNames].count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDBaseCellId"];
    NSString * title = [self getTitleNames][indexPath.row];
    NSString * content = [self getValues][indexPath.row];
    cell.dictView.hidden = YES;
    cell.contentLb.userInteractionEnabled = NO;
    cell.clipsToBounds = YES;
    cell.nameLB.text = title;
    cell.contentLb.text = content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([(NSString *)[self getValues][indexPath.row] length] == 0) {
        return 0.01;
    }
    return 50;
}

@end
