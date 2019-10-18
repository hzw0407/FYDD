//
//  DDBankListView.m
//  FYDD
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDBankListView.h"
#import "DDBankListCell.h"
#import "DDAddBankCell.h"

@interface DDBankListView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DDBankListView


- (void)awakeFromNib{
    [super awakeFromNib];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"DDBankListCell" bundle:nil] forCellReuseIdentifier:@"DDBankListCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDAddBankCell" bundle:nil] forCellReuseIdentifier:@"DDAddBankCellId"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _bankList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _bankList.count) {
        DDBankModel * bank = _bankList[indexPath.row];
        DDBankListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DDBankListCellId"];
        cell.contentLb.text = [NSString stringWithFormat:@"%@(%@)%@",bank.bankType,bank.bankCardNumber,bank.userName];
        return cell;
    }else {
        DDAddBankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDAddBankCellId"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_event) {
        _event(indexPath.row);
    }
}

@end
