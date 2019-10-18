//
//  DDVideoListVC.m
//  FYDD
//
//  Created by mac on 2019/4/3.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDVideoListVC.h"
#import <MJRefresh/MJRefresh.h>
#import "DDVideoListCell.h"
#import "DDVideoListModel.h"
#import "DDWebVC.h"
#import "FYDD-Swift.h"
@interface DDVideoListVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray <DDVideoListModel*>* _dataList;
}

@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDVideoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"演示视频";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem.tintColor = UIColorHex(0x8C9FAD);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getVideoList{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:@"/uas/home/article/getVideoDemoList"
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSArray * datas) {
                       @strongify(self)
                       if (!self) return ;
                       NSMutableArray * dataList = @[].mutableCopy;
                       [self.tableView.mj_header endRefreshing];
                       if (code == 200) {
                           if (datas && [datas isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in datas) {
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
        [_tableView registerClass:[MDCVideoCell class] forCellReuseIdentifier:@"MDCVideoCellId"];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            if (!self) return ;
            [self getVideoList];
        }];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDCVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MDCVideoCellId"];
    DDVideoListModel * model = _dataList[indexPath.row];
    [cell updatePlayWithTitle:model.title url:model.content placeCover:model.coverUrl];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (([UIScreen mainScreen].bounds.size.width) * 9 / 16) + 10;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DDVideoListModel * videoModel = _dataList[indexPath.row];
//    DDWebVC * webVc = [DDWebVC new];
//    webVc.title = @"视频详情";
//    webVc.url = [NSString stringWithFormat:@"%@:%@%@?id=%@",DDAPP_URL,DDPort8003,@"/dd-bss/supervisor/article/homeArticleDetail",videoModel.videoId];
//    [self.navigationController pushViewController:webVc animated:YES];
//}

@end
