//
//  STIdentityDetailVC.m
//  FYDD
//
//  Created by 何志武 on 2019/10/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//  --身份详情

#import "STIdentityDetailVC.h"
#import "STIdentityDetailFunctionCell.h"
#import "STAdvertorialsCell.h"
#import "DDOrderVC.h"
#import "BWPlanVc.h"
#import "DDOpportunityVc.h"
#import "DDApplyRoleVc.h"
#import "DDFootstripObj.h"
#import "STAdvertorialsModel.h"
#import "STAdvertorialsDetailVC.h"
#import "DDWebVC.h"

@interface STIdentityDetailVC ()
<UITableViewDelegate,
UITableViewDataSource,
STIdentityDetailFunctionCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *guideBackgroundView;//引导view
@property (nonatomic, strong) UIView *agentGuideView;//代理方引导view
@property (nonatomic, strong) UIView *implementerGuideView;//实施方引导view
@property (nonatomic, strong) NSMutableArray *listArray;//软文列表数据

@end

@implementation STIdentityDetailVC
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.type == 1 ? @"代理方主页" : @"实施方主页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view).offset(0);
    }];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self loadGuide];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[DDUserManager share] getUserInfo:^{
        [self getAdvertorialsLisy];
    }];
}

#pragma mark - CustomMethod
//获取软文列表
- (void)getAdvertorialsLisy {
    STHttpRequestManager *manager = [STHttpRequestManager shareManager];
    [manager addParameterWithKey:@"type" withValue:self.type == 1 ? @"2" : @"3"];
    [manager requestDataWithUrl:[NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort7001,ADVERTORIALSLIST] withType:RequestGet withSuccess:^(NSDictionary * _Nonnull dict) {
        if (dict && [dict[@"code"] integerValue] == 200) {
            [self.listArray removeAllObjects];
            NSArray * lists = dict[@"data"][@"list"];
            if (lists && [lists isKindOfClass:[NSArray class]]) {
                for (NSDictionary * dic in lists) {
                    STAdvertorialsModel * model = [STAdvertorialsModel modelWithJSON:dic];
                    [self.listArray addObject:model];
                }
            }
            [self.tableView reloadData];
        }
    } withFail:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

//添加引导view
- (void)loadGuide {
    [STTool checkVersionWithSuccess:^(NSDictionary * _Nonnull dict) {
        if (dict && [dict[@"code"] integerValue] == 200) {
            NSString * version = dict[@"data"][@"vNumber"];
            NSString * downLoadURL =  dict[@"data"][@"vUrl"];
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            if ([app_Version isEqualToString:version] && downLoadURL && ![SRUserDefaults boolForKey:Identity_FirstClick]) {
                //和最新的版本一致并且是第一次点击
                if (self.type == 2) {
                    [SRUserDefaults setBool:YES forKey:Identity_FirstClick];
                }
                [[UIApplication sharedApplication].keyWindow addSubview:self.guideBackgroundView];
                if (self.type == 1) {
                    [self.guideBackgroundView addSubview:self.agentGuideView];
                    [self.agentGuideView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.bottom.equalTo(self.guideBackgroundView).offset(0);
                    }];
                }else {
                    [self.guideBackgroundView addSubview:self.implementerGuideView];
                    [self.implementerGuideView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.top.bottom.equalTo(self.guideBackgroundView).offset(0);
                    }];
                }
            }
        }
    } withFail:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - ClickMethod
//点击代理方引导
- (void)agentGuidetap {
    [self.guideBackgroundView removeFromSuperview];
    BWPlanVc *vc = [[BWPlanVc alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//点击实施方引导
- (void)implementerGuideTap {
    [self.guideBackgroundView removeFromSuperview];
    DDOpportunityVc *vc = [[DDOpportunityVc alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SystemDelegate

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return  1;
    }else {
        return self.listArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //功能
        STIdentityDetailFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[STIdentityDetailFunctionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        [cell refreshDataWithType:self.type];
        return cell;
    }else {
        //软文
        STAdvertorialsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[STAdvertorialsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        STAdvertorialsModel *model = self.listArray[indexPath.row];
        [cell refreshWithModel:model];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else {
        return 25;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        return view;
    }else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 5, 15)];
        headerImageView.image = [UIImage imageNamed:@"Home_Line"];
        [headerView addSubview:headerImageView];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 20, 25)];
        headerLabel.text = @"涨知识";
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.font = [UIFont systemFontOfSize:18];
        [headerView addSubview:headerLabel];
        return headerView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 205;
    }else {
        return 110;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        STAdvertorialsDetailVC *vc = [[STAdvertorialsDetailVC alloc] init];
        STAdvertorialsModel *model = self.listArray[indexPath.row];
        vc.model = model;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
     if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
         [cell setLayoutMargins:UIEdgeInsetsZero];
     }
}

#pragma mark - CustomDelegate

#pragma mark - STIdentityDetailFunctionCellDelegate
//点击某个功能
- (void)clickIndex:(NSInteger)index {
    if (index == 1) {
        if (self.type == 1) {
            //代理流程
            DDWebVC * vc = [DDWebVC new];
            vc.title = @"代理流程";
            vc.hidesBottomBarWhenPushed = YES;
            vc.url = [NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort8003,@"/supervisor/manager/extensionFlowDetail"];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            //实施流程
            DDWebVC * vc = [DDWebVC new];
            vc.title = @"实施步骤";
            vc.hidesBottomBarWhenPushed = YES;
            vc.url = [NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort8003,@"/dd-bss/supervisor/manager/onLineFlowDetail"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (index == 2) {
        //我的订单
        DDOrderVC * vc = [[DDOrderVC alloc] init];
        if (self.type == 1) {
            if ([DDUserManager share].user.isExtensionUser == 0) {
                //代理方未认证
                [DDHub hub:@"请先申请成为代理方" view:self.view];
                return ;
            }
            vc.type = 2;
        }else {
            if ([DDUserManager share].user.isOnlineUser == 0) {
                //实施方未认证
                [DDHub hub:@"请先申请成为实施方" view:self.view];
                return ;
            }
            vc.type = 3;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 3) {
        //我的客户
        if (self.type == 1) {
            //之前的百万计划
            if ([DDUserManager share].user.isExtensionUser == 0) {
                //代理方未认证
                [DDHub hub:@"请先申请成为代理方" view:self.view];
                return ;
            }
            BWPlanVc *vc = [[BWPlanVc alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            //之前的商机
            if ([DDUserManager share].user.isOnlineUser == 0) {
                //实施方未认证
                [DDHub hub:@"请先申请成为实施方" view:self.view];
                return ;
            }
            DDOpportunityVc *vc = [[DDOpportunityVc alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//点击申请
- (void)applyClick {
    DDApplyRoleVc *vc = [[DDApplyRoleVc alloc] init];
    if (self.type == 1) {
        //申请代理方
        vc.applyType = DDUserTypePromoter;
    }else {
        //申请实施方
        vc.applyType = DDUserTypeOnline;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GetterAndSetter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)guideBackgroundView {
    if (!_guideBackgroundView) {
        _guideBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _guideBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _guideBackgroundView.userInteractionEnabled = YES;
    }
    return _guideBackgroundView;
}

- (UIView *)agentGuideView {
    if (!_agentGuideView) {
        _agentGuideView = [[UIView alloc] init];
        _agentGuideView.userInteractionEnabled = YES;
        
        UIImageView *imageViewOne = [[UIImageView alloc] init];
        imageViewOne.image = [UIImage imageNamed:@"IdentityGuide1"];
        [_agentGuideView addSubview:imageViewOne];
        [imageViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_agentGuideView).offset(0);
            make.right.equalTo(_agentGuideView).offset(0);
            make.top.equalTo(_agentGuideView).offset(NavigationHeight + 15);
            make.height.equalTo(@(119));
        }];
        
        UIImageView *imageViewTwo = [[UIImageView alloc] init];
        imageViewTwo.image = [UIImage imageNamed:@"IdentityGuide2"];
        [_agentGuideView addSubview:imageViewTwo];
        [imageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_agentGuideView).offset(35);
            make.right.equalTo(_agentGuideView).offset(-35);
            make.top.mas_equalTo(imageViewOne.mas_bottom).offset(-30);
            make.height.equalTo(@(280));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agentGuidetap)];
        [_agentGuideView addGestureRecognizer:tap];
    }
    return _agentGuideView;
}

- (UIView *)implementerGuideView {
    if (!_implementerGuideView) {
        _implementerGuideView = [[UIView alloc] init];
        _implementerGuideView.userInteractionEnabled = YES;
        
        UIImageView *imageViewOne = [[UIImageView alloc] init];
        imageViewOne.image = [UIImage imageNamed:@"IdentityGuide3"];
        [_implementerGuideView addSubview:imageViewOne];
        [imageViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_implementerGuideView).offset(0);
            make.right.equalTo(_implementerGuideView).offset(0);
            make.top.equalTo(_implementerGuideView).offset(NavigationHeight + 15);
            make.height.equalTo(@(119));
        }];
        
        UIImageView *imageViewTwo = [[UIImageView alloc] init];
        imageViewTwo.image = [UIImage imageNamed:@"IdentityGuide4"];
        [_implementerGuideView addSubview:imageViewTwo];
        [imageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_implementerGuideView).offset(35);
            make.right.equalTo(_implementerGuideView).offset(-35);
            make.top.mas_equalTo(imageViewOne.mas_bottom).offset(-30);
            make.height.equalTo(@(280));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(implementerGuideTap)];
        [_implementerGuideView addGestureRecognizer:tap];
    }
    return _implementerGuideView;
}

- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

@end
