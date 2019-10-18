//
//  DDHelpVC.m
//  FYDD
//
//  Created by mac on 2019/4/3.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDHelpVC.h"
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>
#import "DDHelpItemLisit.h"
#import "DDBaseCell.h"
#import "DDHelpDetailVC.h"
#import "DDWebVC.h"

@interface DDHelpVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray <DDHelpItemLisit *>* _itemList;
}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(@0);
    }];
    [self getHelpList];
}

- (void)getHelpList{
    @weakify(self)
    [DDHub hub:self.view];
    [[DDAppNetwork share] get:YES
                         path:@"/uas/user/settings/helpList"
                         body:nil
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       [DDHub dismiss:self.view];
                       if (code == 200) {
                           NSMutableArray * dataList = @[].mutableCopy;
                           if ([data isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in (NSArray *)data){
                                   DDHelpItemLisit * help = [DDHelpItemLisit modelWithJSON:dic];
                                   [dataList addObject:help];
                               }
                           }
                           self->_itemList = dataList;
                           [self.tableView reloadData];
                       }else {
                      
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
        [_tableView registerNib:[UINib nibWithNibName:@"DDBaseCell" bundle:nil] forCellReuseIdentifier:@"DDBaseCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDWalletMoneyCell" bundle:nil] forCellReuseIdentifier:@"DDWalletMoneyCellId"];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemList.count ;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDBaseCellId"];
    DDHelpItemLisit * item = _itemList[indexPath.row];
    cell.nameLB.text = item.title;
    cell.contentLb.text = @"";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDHelpItemLisit * item = _itemList[indexPath.row];
    DDWebVC * webVc = [DDWebVC new];
    webVc.title = item.title;
    webVc.url = [NSString stringWithFormat:@"%@:%@%@?id=%zd",DDAPP_URL,DDPort8003,@"/supervisor/manager/helpDetail",item.heplId];
    [self.navigationController pushViewController:webVc animated:YES];
}

@end
