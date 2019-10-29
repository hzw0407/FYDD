//
//  DDMessageVC.m
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDMessageVC.h"
#import "DDMessageCell.h"
#import "DDTimeCell.h"
#import "DDMessageTopView.h"
#import <UserNotifications/UserNotifications.h>
#import <MJRefresh/MJRefresh.h>
#import "DDMessageModel.h"
#import "DDWalletVC.h"
#import "OrderDetailVC.h"
#import "DDContactListVC.h"
#import "DDMessageDetailVc.h"
#import "DDWebVC.h"
#import "DDOrderDetailVc.h"
#import "DDChangeUserTypeVC.h"

@interface DDMessageVC ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL _isOpenPush;
    NSInteger _currentPage;
    NSArray <DDMessageModel*>* _dataList;
}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息中心";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"已读消息" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonDidClick)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColorHex(0x8C9FAD);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    [self.tableView.mj_header beginRefreshing];
    _isOpenPush = [self isSwitchAppNotification];
}

- (void)getMessageRequest{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/uas/message/getUserMessageList?token=%@&page=%zd",[DDUserManager share].user.token,_currentPage]
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSDictionary * dic) {
                       @strongify(self)
                       if (!self) return ;
                       NSMutableArray * dataList = @[].mutableCopy;
                       [self.tableView.mj_footer endRefreshing];
                       [self.tableView.mj_header endRefreshing];
                       if (code == 200) {
                           if (self->_currentPage != 1) {
                               [dataList addObjectsFromArray:self->_dataList];
                           }
                           NSArray * list = dic[@"list"];
                           for (NSDictionary * key in list) {
                               DDMessageModel * item = [DDMessageModel modelWithJSON:key];
                               [item layout];
                               [dataList addObject:item];
                           }
                           NSInteger total =  [dic [@"total"] integerValue];
  
                           self->_dataList = dataList;
                           [self.tableView reloadData];
                           if (total <= dataList.count) {
                               [self.tableView.mj_footer endRefreshingWithNoMoreData];
                           }
                       }
                   }];
}

- (void)rightButtonDidClick{
    
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorHex(0xeeeeee);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDMessageCell" bundle:nil] forCellReuseIdentifier:@"DDMessageCellId"];//
        [_tableView registerNib:[UINib nibWithNibName:@"DDTimeCell" bundle:nil] forCellReuseIdentifier:@"DDTimeCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDMessageTopView" bundle:nil] forCellReuseIdentifier:@"DDMessageTopViewId"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DDNullCellId"];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            if (!self) return ;
            self->_currentPage = 1;
            [self getMessageRequest];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            if (!self) return ;
            self->_currentPage += 1;
            [self getMessageRequest];
        }];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (!_isOpenPush) {
            DDMessageTopView * cell = [tableView dequeueReusableCellWithIdentifier:@"DDMessageTopViewId"];
            cell.clipsToBounds = YES;
            @weakify(self)
            cell.event = ^{
                [weak_self closeMessage];
            };
            return  cell;
        }else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDNullCellId"];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            return  cell;
        }
        
    }
    DDMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDMessageCellId"];
    DDMessageModel * item = _dataList[indexPath.row -1];
    cell.contentLb.text = item.messageBrief;
    cell.contentLb.textColor = item.state == 0 ? UIColorHex(0x193750) : UIColorHex(0x8C9FAD);
    cell.dayDate.text = item.createTime;
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return _isOpenPush ? 0.01 : 44.0 ;
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url
                                                   options:@{}
                                         completionHandler:^(BOOL success) {
                                         }];
            } else {
            }
        }else{
            //[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]] 应用标识
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }else {
        /*
        DDUserTypeSystem = 1, // 企业用户
        DDUserTypeOnline, // 实施方
        DDUserTypePromoter, // 代理方
         */
        DDMessageModel * item = _dataList[indexPath.row -1];
        if (item.userIdType != [DDUserManager share].user.userType) {
            NSString * text = @"需要切换到企业身份方可查看";
            if (item.userIdType == 2) {
                text = @"需要切换到实施方身份方可查看";
            }else if (item.userIdType == 3) {
                text = @"需要切换到代理方身份方可查看";
            }
            [DDHub hubText:text];
            DDChangeUserTypeVC * vc = [DDChangeUserTypeVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        NSString * jumpURL = item.requestUrl;
        if (jumpURL && [jumpURL rangeOfString:@"fy3tzz://sante/wallet"].location != NSNotFound) {
            DDWalletVC * vc = [DDWalletVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (jumpURL && [jumpURL rangeOfString:@"fy3tzz://sante/orderDetail?orderID="].location != NSNotFound) {
            DDOrderDetailVc * vc = [DDOrderDetailVc new];
            if (item.userIdType == 1) {
                vc.type = 1;
            }else if (item.userIdType == 2) {
                vc.type = 3;
            }else {
                vc.type = 2;
            }
            vc.title = @"订单详情";
            vc.orderId = [jumpURL stringByReplacingOccurrencesOfString:@"fy3tzz://sante/orderDetail?orderID=" withString:@""];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ( jumpURL && [jumpURL rangeOfString:@"fy3tzz://sante/service"].location != NSNotFound){
            DDContactListVC * vc = [DDContactListVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (jumpURL && [jumpURL rangeOfString:@"itunes"].location != NSNotFound) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:jumpURL]];
        }else {
            if ([item.messageContent rangeOfString:@"</"].location != NSNotFound) {
                DDWebVC * vc = [DDWebVC new];
                vc.title = @"消息详情";
                vc.htmlText = item.messageContent;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                DDMessageDetailVc * vc = [DDMessageDetailVc new];
                vc.messageText = item.messageContent;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        if (item.state == 0) {
            item.state = 1;
            @weakify(self)
            [[DDAppNetwork share] get:YES path:[NSString stringWithFormat:@"/uas/message/updateReadMessage?id=%@",item.messageId]
                                 body:@""
                           completion:^(NSInteger code,
                                        NSString *message,
                                        id data) {
                               @strongify(self)
                               if (!self) return ;
                               [self.tableView reloadData];
                               NSLog(@"%@",message);
                           }];
            
        }
    }
}

- (void)closeMessage{
    _isOpenPush = YES;
    [self.tableView reloadData];
}

#pragma mark - 是否开启APP推送
/**是否开启推送*/
- (BOOL)isSwitchAppNotification {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
        __block BOOL result = NO;
        //异步线程中操作是否完成
        __block BOOL inThreadOperationComplete = NO;
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                result = NO;
            }else if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                result = NO;
            }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                result = YES;
            }else {
                result = NO;
            }
            inThreadOperationComplete = YES;
        }];
        
        while (!inThreadOperationComplete) {
            [NSThread sleepForTimeInterval:0];
        }
        return result;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
    {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }else {
            return NO;
        }
        
    }else
    {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type) {
            return YES;
        }else {
            return NO;
        }
    }
#pragma clang diagnostic pop
}

@end
