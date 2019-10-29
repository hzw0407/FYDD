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
@property (nonatomic, strong) UIView *selectView;//选择类型view
@property (nonatomic, assign) NSInteger type;//1实施方 2代理方
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation DDOnlineStudyVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线学习";
    self.view.backgroundColor = [UIColor whiteColor];
    //默认显示代理方
    self.type = 2;
    _onlineDatas = @[].mutableCopy;
    [self.view addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.height.equalTo(@(27));
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(@0);
        make.top.mas_equalTo(self.selectView.mas_bottom);
    }];
    
    [self getOnlineStudyData];
}

- (void)getOnlineStudyData{
    [DDHub hub:self.view];
    @weakify(self)
    NSString * url = [NSString stringWithFormat:@"%@/exam/learn/online/getAllLearn?identityType=%zd",DDAPP_2T_URL, self.type];
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

- (void)btnClick:(UIButton *)btn {
    UIView *lineView = [self.selectView viewWithTag:101];
    [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btn.mas_left).offset(35);
        make.width.equalTo(@(30));
        make.bottom.equalTo(self.selectView).offset(-2);
        make.height.equalTo(@(2));
    }];
    for (UIButton *tempButton in self.buttonArray) {
        if (tempButton.tag == btn.tag) {
            [btn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        }else {
            [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    if (btn.tag == 100) {
        //代理方
        self.type = 2;
        
    }else if (btn.tag == 102) {
        //实施方
        self.type = 1;
    }
    [self getOnlineStudyData];
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

- (UIView *)selectView {
    if (!_selectView) {
        _selectView = [[UIView alloc] init];
        
        //代理方按钮
        UIButton *DLButton = [[UIButton alloc] init];
        [DLButton setTitle:@"代理方学习" forState:UIControlStateNormal];
        [DLButton setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        DLButton.titleLabel.font = [UIFont systemFontOfSize:16];
        DLButton.tag = 100;
        [DLButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:DLButton];
        [DLButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_selectView).offset(55);
            make.width.equalTo(@(100));
            make.top.equalTo(_selectView).offset(0);
            make.height.equalTo(@(25));
        }];
        
        //线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor mainColor];
        lineView.tag = 101;
        [_selectView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(DLButton.mas_left).offset(35);
            make.width.equalTo(@(30));
            make.bottom.equalTo(_selectView).offset(-2);
            make.height.equalTo(@(2));
        }];
        
        //实施方按钮
        UIButton *SSButton = [[UIButton alloc] init];
        [SSButton setTitle:@"实施方学习" forState:UIControlStateNormal];
        [SSButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        SSButton.titleLabel.font = [UIFont systemFontOfSize:16];
        SSButton.tag = 102;
        [SSButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:SSButton];
        [SSButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_selectView).offset(-55);
            make.width.equalTo(@(100));
            make.top.equalTo(_selectView).offset(0);
            make.height.equalTo(@(25));
        }];
        
        [self.buttonArray addObject:DLButton];
        [self.buttonArray addObject:SSButton];
    }
    return _selectView;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}


@end
