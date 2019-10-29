//
//  DDSettingVC.m
//  FYDD
//
//  Created by mac on 2019/3/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDSettingVC.h"
#import "DDUserAvatarCell.h"
#import "DDBaseCell.h"
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>
#import "BRStringPickerView.h"
#import "DDCommitCell.h"
#import "DDModifyPasswordVC.h"
#import "DDPayPasswordVC.h"
#import "DDWebVC.h"
#import "DDAlertView.h"
#import "DDHelpVC.h"
#import "DDBadingWechatVC.h"
#import "DDUserLogoutCell.h"
#import "DDCCheckAppVersionVc.h"
#import <SDWebImage/SDWebImage.h>

@interface DDSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation DDSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDUserAvatarCell" bundle:nil] forCellReuseIdentifier:@"DDUserAvatarCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDBaseCell" bundle:nil] forCellReuseIdentifier:@"DDBaseCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDCommitCell" bundle:nil] forCellReuseIdentifier:@"DDCommitCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDUserLogoutCell" bundle:nil] forCellReuseIdentifier:@"DDUserLogoutCellId"];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)topMenuView:(NSInteger)type{
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 8) {
        DDUserLogoutCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDUserLogoutCellId"];
        return cell;
    }else {
        DDBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDBaseCellId"];
        NSString * title = @"";
        NSString * content = @"";
        
        NSArray * titles = @[@"修改登录密码",
                             @"支付密码",
                             @"绑定、解绑微信",
                             @"关于我们",
                             @"用户协议",
                             @"清除缓存",
                             @"帮助",
                             @"版本更新"];
        
        title = titles[indexPath.row];
        content = @"";
        cell.switchOn.hidden = YES;
        cell.dictView.hidden = NO;
        cell.clipsToBounds = YES;
        cell.contentLb.textColor = UIColorHex(0x6C6969);
        if (indexPath.row == 2) {
            content = [DDUserManager share].user.wechatOpenid.length ? @"已绑定" : @"未绑定";
        }else if (indexPath.row == 5){
            // 计算缓存大小
             double kb = [[SDImageCache sharedImageCache] totalDiskSize] / 1024;
            if (kb > 1024) {
                content = [NSString stringWithFormat:@"%.1f M",kb / 1024];
            }else {
                content = [NSString stringWithFormat:@"%.1f kb",kb ];
            }
            cell.contentLb.textColor = UIColorHex(0x2996EB);
        }
//        else if (indexPath.row == 2){
//            cell.switchOn.hidden = NO;
//            cell.switchOn.on = [DDUserManager share].user.isAutoRenew == 1;
//            cell.dictView.hidden = YES;
//            @weakify(self)
//            cell.event = ^(NSInteger index) {
//                @strongify(self)
//                [DDHub hub:self.view];
//                NSString * body = [NSString stringWithFormat:@"{\"isAutoRenew\" : \"%@\"}",index == 1 ? @"1" : @"2"];
//                [[DDAppNetwork share] get:NO
//                                     path:[NSString stringWithFormat:@"/uas/user/user/userInfo/updateUserInfo?token=%@",[DDUserManager share].user.token]
//                                     body:body
//                               completion:^(NSInteger code,
//                                            NSString *message,
//                                            id data) {
//                                   @strongify(self)
//                                   if (!self) return ;
//                                   [DDHub dismiss:self.view];
//                                   [[DDUserManager share] getUserInfo:^{
//                                       @strongify(self)
//                                       if (!self) return ;
//                                       [self.tableView reloadData];
//                                   }];
//                               }];
//            };
//        }
        cell.nameLB.text = title;
        cell.contentLb.text = content;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * url = @"";
    NSString * title = @"";
    if (indexPath.row == 0) {
        DDModifyPasswordVC  * vc = [DDModifyPasswordVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        DDPayPasswordVC  * vc = [DDPayPasswordVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 8) {
        [DDAlertView showTitle:@"温馨提示"
                      subTitle:@"您确定退出当前账户"
                     sureEvent:^{
                         [[DDUserManager share] clean];
                         [[NSNotificationCenter defaultCenter] postNotificationName:DD_LOGIN_NOTE object:nil];
                         
        } cancelEvent:^{
            
        }];
    }else if (indexPath.row == 2) {
        DDBadingWechatVC * vc = [DDBadingWechatVC new];
        vc.title = [DDUserManager share].user.wechatOpenid ? @"解绑微信" : @"绑定微信";
        [self.navigationController pushViewController:vc animated:YES];

    }else if (indexPath.row == 3) {
        
        title = @"关于我们";
        url = [NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort8003,@"/dd-bss/supervisor/manager/aboutWeDetail"];

    }else if (indexPath.row == 4) {
        
        url = [NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort8003,@"/dd-bss/supervisor/manager/userAgreementDetail"];
        title = @"用户协议";
        

    }else if(indexPath.row == 5) {
        @weakify(self)
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            @strongify(self)
            [DDHub hub:@"缓存清除成功" view:self.view];
            [self.tableView reloadData];
        }];
    }else if(indexPath.row == 6) {
        DDHelpVC * help = [DDHelpVC new];
        [self.navigationController pushViewController:help animated:YES];
    }else if(indexPath.row == 7) {
        DDCCheckAppVersionVc * vc = [DDCCheckAppVersionVc new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([url hasPrefix:@"http:"]) {
        DDWebVC * vc = [DDWebVC new];
        vc.url = url;
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

@end
