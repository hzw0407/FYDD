//
//  DDCommentVC.m
//  FYDD
//
//  Created by mac on 2019/4/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDCommentVC.h"
#import "DDClerkTopCell.h"
#import "DDClerkOrderCell.h"
#import "OrderDetailVC.h"
#import <MJRefresh.h>
#import "DDOrderTopView.h"
#import "DDOrderInfo.h"
#import "DDOrderPayVC.h"
#import "DDCommentCell.h"
#import "DDCommentCommitCell.h"
#import "DDPaySuccessVC.h"

@interface DDCommentVC ()<UITableViewDelegate,UITableViewDataSource>{
    double _commentValue1;
    double _commentValue2;
    double _commentValue3;
    
    double _commentValue4;
    double _commentValue5;
    double _commentValue6;
    
}
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation DDCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.top.mas_equalTo(@0);
    }];
    self->_commentValue1 = 5.0;
    self->_commentValue2 = 5.0;
    self->_commentValue3 = 5.0;
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorHex(0xEFEFF6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDCommentCell" bundle:nil] forCellReuseIdentifier:@"DDCommentCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDCommentCommitCell" bundle:nil] forCellReuseIdentifier:@"DDCommentCommitCellId"];

    }
    return _tableView;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.row == 1) {
        DDCommentCommitCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCommentCommitCellId"];
        cell.event = ^{
            @strongify(self)
            [self commit];
        };
        return cell;
    }else {
        DDCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCommentCellId"];
        cell.clipsToBounds = YES;
        if (indexPath.row == 0) {
            cell.codeNameLb1.text = @"服务态度:";
            cell.codeNameLb2.text = @"系统介绍";
            cell.codeNameLb3.text = @"专业水平";
            cell.nameLb.text = @"代理方评价";
            [cell.userBtn setTitle:yyTrimNullText(_name) forState:UIControlStateNormal];
        }else {
            cell.codeNameLb1.text = @"服务态度:";
            cell.codeNameLb2.text = @"系统介绍";
            cell.codeNameLb3.text = @"专业水平";
            cell.nameLb.text = @"实施方评价";
            [cell.userBtn setTitle:yyTrimNullText(_name1) forState:UIControlStateNormal];
        }
        
        cell.CommentBlock = ^(NSInteger type, CGFloat progressive) {
            @strongify(self)
            if (indexPath.row == 0) {
                if (type == 0) {
                    self->_commentValue1 = progressive;
                }else if (type == 1) {
                    self->_commentValue2 = progressive;
                }else if (type == 2) {
                    self->_commentValue3 = progressive;
                }
            }else {
                if (type == 0) {
                    self->_commentValue4 = progressive;
                }else if (type == 1) {
                    self->_commentValue5 = progressive;
                }else if (type == 2) {
                    self->_commentValue6 = progressive;
                }
            }
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (yyTrimNullText(_name).length == 0) {
            return 0.01;
        }
    }
    return 175;
}

-(void)commit{
    [DDHub hub:self.view];
    NSString * body = [NSString stringWithFormat:@"{\"orderId\" : \"%@\",\"orderNumber\" : \"%@\",\"extension4\" : \"%.1f\",\"extension5\" : \"%.1f\",\"extension6\" : \"%.1f\",\"onlineEvaluate1\" : \"%.1f\",\"onlineEvaluate2\" : \"%.1f\",\"onlineEvaluate3\" : \"%.1f\"}",_orderId,_orderNumber,_commentValue1,_commentValue2,_commentValue3,_commentValue4,_commentValue5,_commentValue6];
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/tss/order/evaluate/add?token=", [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
        
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               DDPaySuccessVC * vc = [DDPaySuccessVC new];
                               vc.isComment = YES;
                               vc.orderId = self.orderNumber;
                               [DDAppManager gotoVC:vc navigtor:self.navigationController];
                           });
                       }else {
                           [DDHub hub:@"评价成功" view:self.view];
                       }
                   }];
}


@end
