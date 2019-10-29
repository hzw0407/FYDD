//
//  DDAuthenVc.m
//  FYDD
//
//  Created by wenyang on 2019/8/26.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDAuthenVc.h"
#import "DDOnlineStudyVc.h"
#import "DDAuthenMoniVc.h"
#import "DDAuthenTypeCell.h"
#import <Masonry/Masonry.h>
#import "DDApplyRoleVc.h"
#import "DDSequentialExercisesVc.h"
#import "DDSequentialTypeChooseVc.h"
#import "DDLADetailVc.h"

@interface DDAuthenVc ()<UITableViewDelegate,UITableViewDataSource> {
    BOOL _hasRecordOnlineUser;
    BOOL _hasRecordPromoter;
}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDAuthenVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"报名";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(@0);
    }];
}

-  (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getRecordData:DDUserTypePromoter];
    [self getRecordData:DDUserTypeOnline];
    @weakify(self)
    [[DDUserManager share] getUserInfo:^{
        @strongify(self)
        [self.tableView reloadData];
    }];
}

- (void)getRecordData:(DDUserType )userType{
    @weakify(self)
    [DDHub hub:self.view];
    NSString * url = [NSString stringWithFormat:@"%@/exam/question/bank/sequence/hasSequenceRecord?token=%@&identityType=%@",DDAPP_2T_URL,[DDUserManager share].user.token, userType == DDUserTypePromoter ? @"2" : @"1"];
    [[DDAppNetwork share] get:YES
                          url:url
                   parameters:nil
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           BOOL record = [[NSString stringWithFormat:@"%@",data] boolValue];
                           [DDHub dismiss:self.view];
                           if (userType == DDUserTypeOnline) {
                               self->_hasRecordOnlineUser = record;
                           }else {
                               self->_hasRecordPromoter = record;
                           }
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
        [_tableView registerNib:[UINib nibWithNibName:@"DDAuthenTypeCell" bundle:nil] forCellReuseIdentifier:@"DDAuthenTypeCellId"];
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDUserType type = indexPath.row == 0 ?  DDUserTypePromoter : DDUserTypeOnline;
    DDAuthenTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDAuthenTypeCellId"];
    cell.userType = type;
    // 授权书
    @weakify(self)
    cell.authorizeBlock = ^(DDUserType userType) {
        @strongify(self)
        DDLADetailVc * vc = [DDLADetailVc new];
        vc.userType = indexPath.row == 0 ?  DDUserTypePromoter : DDUserTypeOnline;
        [self.navigationController pushViewController:vc animated:YES];
    };
    // 申请
    cell.applyBlock = ^(DDUserType userType) {
        @strongify(self)
        DDApplyRoleVc * vc =  [DDApplyRoleVc new];
        vc.applyType = type;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    cell.menuBlock = ^(DDUserType userType, NSInteger index) {
        @strongify(self)
        if (index == 1) {
            // 顺序练习
            if ((  userType == DDUserTypeOnline   &&   !self->_hasRecordOnlineUser)
                ||(userType == DDUserTypePromoter && !self->_hasRecordPromoter)) {
                DDSequentialExercisesVc * vc = [DDSequentialExercisesVc new];
                vc.isContinue = NO;
                vc.userType = userType;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                DDSequentialTypeChooseVc  * vc = [DDSequentialTypeChooseVc new];
                vc.userType = userType;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if (index == 2) {
            //模拟考试
            DDAuthenMoniVc * vc = [DDAuthenMoniVc new];
            vc.isSilmimator = YES;
            vc.userType = userType;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            //开始考试
            DDAuthenMoniVc * vc = [DDAuthenMoniVc new];
            vc.isSilmimator = NO;
            vc.userType = userType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}

@end
