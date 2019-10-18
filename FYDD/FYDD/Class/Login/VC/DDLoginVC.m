//
//  DDLoginVC.m
//  FYDD
//
//  Created by mac on 2019/2/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDLoginVC.h"
#import "DDUserBindPhoneVC.h"
#import "DDEditUserVC.h"
#import "DDForgetVC.h"
#import "DDAppNetwork.h"
#import "DDHub.h"
#import <UMShare/UMShare.h>
#import "DDAlertView.h"
#import "DDWebVC.h"

@interface DDLoginVC () {
    BOOL _isPhoneLogin;
    NSTimer * _timer;
    NSInteger _timerCount;
}
@property (weak, nonatomic) IBOutlet UITextField *loginNameTd;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordTd;
@property (weak, nonatomic) IBOutlet UIImageView *iconView1;
@property (weak, nonatomic) IBOutlet UIImageView *iconView2;
@property (weak, nonatomic) IBOutlet UIView *dictorView;
@property (weak, nonatomic) IBOutlet UIButton *phoneTypeButton;
@property (weak, nonatomic)  UIButton *temButton;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UIView *wechatView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consValue;
@property (weak, nonatomic) IBOutlet UILabel *firstLb;
@end

@implementation DDLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.temButton = self.phoneTypeButton;
    _codeButton.layer.borderWidth = 1;
    _codeButton.clipsToBounds = YES;
    _codeButton.layer.borderColor = [DDAppManager share].appTintColor.CGColor;
    _isPhoneLogin = YES;
    self.topView.hidden = NO;
    if (iPhoneXAfter) {
        _consValue.constant = 30;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[DDUserManager share] clean];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController setNavigationBarHidden:true animated:false];
    if ([DDUserManager share].tokenIsVaild) {
        [DDUserManager share].tokenIsVaild = NO;
        [DDAlertView showTitle:@"提示"
                      subTitle:@"登录信息过期，请重新登录"
                   cancelEvent:^{
            
        }];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.shadowImage = nil;
}

// 切换登录方式
- (IBAction)loginTypeButtonDidClick:(UIButton *)sender {
    _temButton.selected = false;
    sender.selected = true;
    _temButton = sender;
    _isPhoneLogin = sender.tag == 0;
    _firstLb.hidden = sender.tag == 1;
    _forgetButton.hidden = sender.tag == 0;
    _codeButton.hidden = !_isPhoneLogin;
    _loginNameTd.text = @"";
    _loginPasswordTd.text = @"";
    _loginPasswordTd.secureTextEntry = sender.tag == 1;
    _loginPasswordTd.keyboardType = sender.tag == 0 ? UIKeyboardTypePhonePad : UIKeyboardTypeDefault;
    _loginPasswordTd.placeholder = _isPhoneLogin ? @"请输入短信验证码" : @"请输入密码";
    _iconView1.image = [UIImage imageNamed:sender.tag == 0 ? @"icon_tel" : @"icon_user"];
    _iconView2.image = [UIImage imageNamed:sender.tag == 0 ? @"icon_code" : @"icon_pwd"];
    self.cons.constant = self->_dictorView.frame.size.width * sender.tag;
    [self.view layoutIfNeeded];
    
}

// 登录
- (IBAction)loginButtonDidClick:(UIButton *)sender {
    NSString * phone = _loginNameTd.text;
    NSString * verifyCode = _loginPasswordTd.text;
    if (phone.length ==  0) {
        [DDHub hub:@"请输入手机号" view:self.view];
        return;
    }
    if (verifyCode.length ==  0) {
        [DDHub hub:_isPhoneLogin ?  @"请输入验证码" : @"请输入密码" view:self.view];
        return;
    }
    
    // 手机号登录
    [DDHub hub:self.view];
    if (_isPhoneLogin) {
        @weakify(self)
        NSString * body = [NSString stringWithFormat:@"{\"userName\" : %@ , \"veritiCode\" : %@}",phone,verifyCode];
        [[DDAppNetwork share] get:NO
                             path:@"/uas/user/user/login/veritiCodeLogin"
                             body:body
                       completion:^(NSInteger code, NSString *message, id data) {
                           @strongify(self)
                           if (code == 200) {
                               [DDHub dismiss:self.view];
                               DDUserManager * userManager =  [DDUserManager share];
                               userManager.user = [DDUser modelWithJSON:data];
                               if (userManager.user.isFinishInfo == 0) {
                                   [DDUserManager share].isLogged = YES;
                                   [[DDUserManager share] save];
                                   [[NSNotificationCenter defaultCenter] postNotificationName:DD_GOTO_MAIN object:nil];
                               }else {
                                   DDEditUserVC * vc = [DDEditUserVC new];
                                   [self.navigationController pushViewController:vc animated:true];
                               }
                           }else {
                               [DDHub hub:message view:self.view];
                           }
                       }];
    // 账户密码登录
    }else {
        @weakify(self)
        NSString * body = [NSString stringWithFormat:@"{\"userName\" : \"%@\" , \"password\" : \"%@\"}",phone,verifyCode];
        [[DDAppNetwork share] get:NO
                             path:@"/uas/user/user/login/userAccountLogin"
                             body:body
                       completion:^(NSInteger code, NSString *message, id data) {
                           @strongify(self)
                           if (code == 200) {
                               [DDHub dismiss:self.view];
                               DDUserManager * userManager =  [DDUserManager share];
                               userManager.user = [DDUser modelWithJSON:data];
                               if (userManager.user.isFinishInfo == 0) {
                                   [DDUserManager share].isLogged = YES;
                                   [[DDUserManager share] save];
                                   [[NSNotificationCenter defaultCenter] postNotificationName:DD_GOTO_MAIN object:nil];
                                   // 绑定用户信息
                               }else {
                                   DDEditUserVC * vc = [DDEditUserVC new];
                                   [self.navigationController pushViewController:vc animated:true];
                               }
                           }else {
                               [DDHub hub:message view:self.view];
                           }
                       }];
    }
  
}

// 用户协议
- (IBAction)userAgreementButtonDidClick {
    DDWebVC * vc = [DDWebVC new];
    vc.url = [NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort8003,@"/dd-bss/supervisor/manager/userAgreementDetail"];
    vc.title = @"用户协议";
    [self.navigationController pushViewController:vc animated:YES];
}

// 微信登录
- (IBAction)wechatLoginButtonDidClick {
   
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
        }
    }];
//  DDUserBindPhoneVC * vc = [DDUserBindPhoneVC new];
//  [self.navigationController pushViewController:vc animated:true];
}

- (void)wechatLogin:(NSString *)openId
           nickName:(NSString *)nickName
                sex:(NSString *)sex
            address:(NSString *)address
         userAvatar:(NSString *)userAvatar{
    [DDHub hub:self.view];
    @weakify(self)
    NSString * body = [NSString stringWithFormat:@"{\"openId\" : \"%@\" , \"nickName\" : \"%@\" ,\"sex\" : \"%@\" ,\"address\" : \"%@\" , \"userAvatar\" : \"%@\"}",openId,openId,[sex isEqualToString:@"男"] ? @"1" : @"2",address,userAvatar];
    [[DDAppNetwork share] get:NO
                         path:@"/uas/user/user/login/wechatLogin"
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           DDUserManager * userManager =  [DDUserManager share];
                           userManager.user = [DDUser modelWithJSON:data];
                           if (userManager.user.isFinishInfo == 2) {
                               DDEditUserVC * vc = [DDEditUserVC new];
                               vc.wechart = YES;
                               [self.navigationController pushViewController:vc animated:true];
                           }else {
                               [DDUserManager share].isLogged = YES;
                               [[DDUserManager share] save];
                               [[NSNotificationCenter defaultCenter] postNotificationName:DD_GOTO_MAIN object:nil];
                           }
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

// 忘记密码
- (IBAction)fortgetPassowordButtonDidClick {
    DDForgetVC * vc = [DDForgetVC new];
    [self.navigationController pushViewController:vc animated:true];
}

// 获取验证码
- (IBAction)codeBtnDidClick {
    NSString * phone = _loginNameTd.text;
    if (phone.length ==  0) {
        [DDHub hub:@"请输入手机号" view:self.view];
        return;
    }
    @weakify(self)
    self.codeButton.userInteractionEnabled = NO;
    NSString * body = [NSString stringWithFormat:@"{\"mobile\" : %@}",phone];
    [[DDAppNetwork share] get:NO
                         path:@"/uas/messageSend/sms/sendValidateCode"
                   body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       // 成功
                       if (code == 200) {
                          [DDHub hub:@"获取验证码成功" view:self.view];
                          [self startTimer];
                       }else {
                           self.codeButton.userInteractionEnabled = YES;
                          [DDHub hub:@"获取验证码失败" view:self.view];
                       }
    }];
}

// 倒计时
- (void)startTimer{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
    _codeButton.layer.borderColor = UIColorHex(0xdddddd).CGColor;
    [_codeButton setTitleColor:UIColorHex(0xdddddd) forState:UIControlStateNormal];
    
    _codeButton.userInteractionEnabled = NO;
    _timerCount = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerLoop) userInfo:nil repeats:YES];
}

- (void)timerLoop{
    _timerCount -= 1;
    if (_timerCount == 0){
        [_timer invalidate];
        _timer = nil;
        _codeButton.userInteractionEnabled = YES;
        _codeButton.layer.borderColor = [DDAppManager share].appTintColor.CGColor;
        [_codeButton setTitleColor:[DDAppManager share].appTintColor forState:UIControlStateNormal];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        return;
    }
    [_codeButton setTitle:[NSString stringWithFormat:@"%zd",_timerCount] forState:UIControlStateNormal];
}

- (IBAction)backBtnDidClick {
   [[NSNotificationCenter defaultCenter] postNotificationName:DD_GOTO_MAIN object:nil];
}
@end
