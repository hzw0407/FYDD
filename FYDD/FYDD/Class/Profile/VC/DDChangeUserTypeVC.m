//
//  DDChangeUserTypeVC.m
//  FYDD
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDChangeUserTypeVC.h"
#import "DDUserTypeCell.h"
#import "DDAuthenticationIdCardVcView.h"
#import "DDAlertView.h"
#import "DDApplyRoleVc.h"

@interface DDChangeUserTypeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation DDChangeUserTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换身份";
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
        _tableView.backgroundColor = UIColorHex(0xF3F4F6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDUserTypeCell" bundle:nil] forCellReuseIdentifier:@"DDUserTypeCellId"];
    }
    return _tableView;
}

- (void)topMenuView:(NSInteger)type{
    
}
    
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDUserTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDUserTypeCellId"];
    DDUserType type = DDUserTypeSystem;
    if (indexPath.row == 1) {
        type = DDUserTypeOnline;
    }else  if (indexPath.row == 2) {
        type = DDUserTypePromoter;
    }
    cell.showType = type;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDUserType type = DDUserTypeSystem;
    if (indexPath.row == 1) {
        type = DDUserTypeOnline;
    }else  if (indexPath.row == 2) {
        type = DDUserTypePromoter;
    }
    if (type == [DDUserManager share].user.userType){
        return;
    }
    
//    if (type != DDUserTypeSystem){
//        if ([DDUserManager share].user.realAuthentication != 1){
//            DDAuthenticationIdCardVcView * vc = [DDAuthenticationIdCardVcView new];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [DDHub hub:@"未实名认证，请先认证" view:vc.view];
//            });
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
//    }

    switch (type) {
        case DDUserTypeSystem:
            break;
        case DDUserTypeOnline:{
            // 未认证实施方案
            if([DDUserManager share].user.isAuth == -10  ||
               [DDUserManager share].user.isAuth == -2){
                DDApplyRoleVc * vc = [DDApplyRoleVc new];
                vc.applyType = type;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }break;
        case DDUserTypePromoter:
            if ([DDUserManager share].user.isExtensionUser == 0 ||
                [DDUserManager share].user.isExtensionUser == 2) {
                DDApplyRoleVc * vc = [DDApplyRoleVc new];
                vc.applyType = type;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            break;
            
        default:
            break;
    }
    
    [self switchUserIdentityRequestReqeust:type];
}

- (void)switchUserIdentityRequestReqeust:(DDUserType)type{
     NSInteger status = [DDUserManager share].user.isExtensionUser;
    [DDHub hub:self.view];
    @weakify(self)
    [[DDUserManager share] setCurrenUserType:type
                                  completion:^(BOOL suc , NSString * message) {
                                      @strongify(self)
                                      if (!self) return ;
                                      if(suc) {
//                                          if (type == DDUserTypePromoter && status != 1){
//                                              [DDHub hub:@"代理方身份审核中，请联系企业引擎" view:self.view];
//                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                                  [[NSNotificationCenter defaultCenter] postNotificationName:DD_GOTO_MAIN object:nil];
//                                              });
//                                          }else {
                                              [DDUserManager share].user.userType = type;
                                              [[DDUserManager share] save];
                                              [DDHub dismiss:self.view];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:DD_GOTO_MAIN object:nil];
//                                          }
                                      }else {
                                          [DDHub hub:message view:self.view];
                                      }
                                      [[DDUserManager share] getUserInfo:^{
                                          [self.tableView reloadData];
                                      }];
                                  }];
}


@end
