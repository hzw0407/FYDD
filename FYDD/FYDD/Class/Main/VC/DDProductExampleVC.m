//
//  DDProductExampleVC.m
//  FYDD
//
//  Created by mac on 2019/4/3.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProductExampleVC.h"
#import <MJRefresh/MJRefresh.h>
#import "DDVideoListCell.h"
#import "DDVideoListModel.h"
#import "DDWebVC.h"

@interface DDProductExampleVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray <DDVideoListModel*>* _dataList;
}

@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDProductExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成功案例";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem.tintColor = UIColorHex(0x8C9FAD);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    [self.tableView.mj_header beginRefreshing];
    
}


- (void)getDataList{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:@"/uas/home/article/getSucccessCaseList"
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSArray * data) {
                       @strongify(self)
                       if (!self) return ;
                       NSMutableArray * dataList = @[].mutableCopy;
                       [self.tableView.mj_header endRefreshing];
                       if (code == 200) {
                           if (data && [data isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in data) {
                                   DDVideoListModel * videos = [DDVideoListModel modelWithJSON:dic];
                                   [dataList addObject:videos];
                               }
                               self->_dataList = dataList;
                           }
                       }
                       [self.tableView reloadData];
                   }];
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorHex(0xeeeeee);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDVideoListCell" bundle:nil] forCellReuseIdentifier:@"DDVideoListCellId"];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            if (!self) return ;
            [self getDataList];
        }];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDVideoListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDVideoListCellId"];
    cell.video = _dataList[indexPath.row];
    cell.videoView.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDVideoListModel * videoModel = _dataList[indexPath.row];
    DDWebVC * webVc = [DDWebVC new];
    webVc.title = @"案例详情";
    webVc.url = [NSString stringWithFormat:@"%@:%@%@?id=%@",DDAPP_URL,DDPort8003,@"/dd-bss/supervisor/article/homeArticleDetail",videoModel.videoId];
    [self.navigationController pushViewController:webVc animated:YES];
}



@end
