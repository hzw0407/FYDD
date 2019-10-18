//
//  DDBadingWechatVC.m
//  FYDD
//
//  Created by mac on 2019/4/15.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDBadingWechatVC.h"
#import <UMShare/UMShare.h>
#import "DDEditUserVC.h"
#import "DDAlertView.h"
@interface DDBadingWechatVC ()

@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation DDBadingWechatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}


- (void)updateUI{
    @weakify(self)
    [[DDUserManager share] getUserInfo:^{
        @strongify(self)
        [DDHub dismiss:self.view];
        self.descLb.text = [DDUserManager share].user.wechatOpenid.length ? @"已成功绑定，您可以通过微信账号登录三特嘀嗒平台" : @"未绑定，绑定后，您可以通过微信账号登录三特嘀嗒平台";
        [self.commitBtn setTitle:[DDUserManager share].user.wechatOpenid.length ? @"解绑" : @"绑定" forState:UIControlStateNormal];
    }];
}

- (IBAction)buttonDidClick {
    // 解绑
     @weakify(self)
    if ([DDUserManager share].user.wechatOpenid.length > 0) {
        [DDAlertView showTitle:@"解绑微信账号"
                      subTitle:@"微信账号为当前登录账号，解绑后请通过其他绑定账号重新登录三特嘀嗒"
                   actionName1:@"解绑"
                   actionName2:@"取消"
                     sureEvent:^{
                         [DDHub hub:self.view];
                        @strongify(self)
                         [[DDAppNetwork share] get:NO
                                              path:YYFormat(@"/uas/user/user/userInfo/unbindWechat?token=", [DDUserManager share].user.token)
                                              body:@""
                                        completion:^(NSInteger code, NSString *message, id data) {
                                            if (code == 200) {
                                                [DDHub dismiss:self.view];
                                                [[DDUserManager share] clean];
                                                [[NSNotificationCenter defaultCenter] postNotificationName:DD_LOGIN_NOTE object:nil];
                                                [self updateUI];
                                            }else {
                                                [DDHub hub:message view:self.view];
                                            }
                                        }];
        } cancelEvent:^{
            
        }];
        
    }else  {
        [self wechatLoginButtonDidClick];
        
    }
}

- (void)wechatLoginButtonDidClick {
    
    @weakify(self)
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession
                                        currentViewController:self
                                                   completion:^(id result, NSError *error) {
                                                       @strongify(self)
                                                       if (error) {
                                                       } else {
                                                           UMSocialUserInfoResponse *resp = result;
                                                           NSString * address = [NSString stringWithFormat:@"%@%@%@",resp.originalResponse[@"country"],resp.originalResponse[@"province"],resp.originalResponse[@"city"]];
                                                           [self wechatLogin:resp.openid nickName:resp.name sex:resp.unionGender address:address userAvatar:resp.iconurl];
                                                           [self updateUI];
                                                       }
                                                   }];
}

- (void)wechatLogin:(NSString *)openId
           nickName:(NSString *)nickName
                sex:(NSString *)sex
            address:(NSString *)address
         userAvatar:(NSString *)userAvatar{
    [DDHub hub:self.view];
    @weakify(self)
    NSString * body = [NSString stringWithFormat:@"{\"openId\" : \"%@\" , \"nickName\" : \"%@\" , \"userAvatar\" : \"%@\"}",openId,nickName,userAvatar];
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/uas/user/user/userInfo/bindWechat?token=", [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       [DDHub hub:message view:self.view];
                       if (code == 200) {
                           [self updateUI];
                       }else {
                           
                       }
                   }];
}

@end
