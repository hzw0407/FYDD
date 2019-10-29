//
//  DDApplyRoleVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDApplyRoleVc.h"
#import "DDProductAgreeServiceVc.h"
#import "DDAlertInputView.h"

@interface DDApplyRoleVc () {
    BOOL _isSecrecy;
    BOOL _isPromise;
}
@property (weak, nonatomic) IBOutlet UILabel *descLb1;
@property (weak, nonatomic) IBOutlet UILabel *descLb2;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconView1;
@property (weak, nonatomic) IBOutlet UIImageView *iconView2;
@property (weak, nonatomic) IBOutlet UILabel *textLb;

@end

@implementation DDApplyRoleVc

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * content = @"       非常感谢您成为企业引擎实施方团体的一员，成为实施方需要需要经过三特公司的在线学习，在线考核，考核合格方可成为正式的实施方。        具体事宜请查看《认证》中的在线学习资料";
    if (_applyType == DDUserTypeOnline) {
        self.title = @"申请成为实施方";
        [self.nextButton setTitle:@"申请成为实施方" forState:UIControlStateNormal];
    }else {
        [self.nextButton setTitle:@"申请成为代理方" forState:UIControlStateNormal];
        self.title = @"申请成为代理方";
        content = [content stringByReplacingOccurrencesOfString:@"实施方" withString:@"代理方"];
    }
    self.textLb.text = content;
    _nextButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _nextButton.layer.shadowOffset = CGSizeMake(0,3);
    _nextButton.layer.shadowRadius = 6;
    _nextButton.layer.shadowOpacity = 1;
    _nextButton.layer.cornerRadius = 20;
    
    _descLb1.attributedText = [self getAttText:@"请详细阅读" textLas:@"《保密协议》"];
    _descLb2.attributedText = [self getAttText:@"请详细阅读" textLas:@"《服务承诺》"];
}

- (NSAttributedString * )getAttText:(NSString *)text textLas:(NSString *)last{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: UIColorHex(0x131313)}];
     NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:last attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: UIColorHex(0x2996EB)}];
    [string appendAttributedString:string1];
    return string;
}

- (IBAction)commitApplyRoleClick:(id)sender {
    // 判断是不是有上线
    if ([DDUserManager share].user.promoteOnline.length == 0 &&
        _applyType == DDUserTypePromoter) {
        @weakify(self)
        [DDAlertInputView showEvent:^(NSString *text) {
            [DDHub hub:self.view];
            [[DDAppNetwork share] get:YES
                                 path:[NSString stringWithFormat:@"/uas/user/extension/setOrdersExtension?token=%@&extensionCode=%@",[DDUserManager share].user.token,text]
                                 body:@""
                           completion:^(NSInteger code, NSString *message, id data) {
                               @strongify(self)
                               if (!self) return ;
                               [DDHub dismiss:self.view];
                               if (code == 200) {
                                   [self commitAply];
                               }else {
                                   [DDHub hub:message view:self.view];
                               }
                           }];
            
        } cancelEvent:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }else if (_applyType == DDUserTypeOnline) {
        STHttpRequestManager *manager = [STHttpRequestManager shareManager];
        [manager requestDataWithUrl:[NSString stringWithFormat:@"%@:%@/uas/user/online/applyForAsUserOnline?token=%@",DDAPP_URL,DDPort7001,[DDUserManager share].user.token] withType:RequestPost withSuccess:^(NSDictionary * _Nonnull dict) {
            [DDHub dismiss:self.view];
            if (dict && [dict[@"code"] integerValue] == 200) {
                [self commitAply];
            }else {
                [DDHub hub:dict[@"message"] view:self.view];
            }
        } withFail:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [DDHub dismiss:self.view];
            [DDHub hub:error.domain view:self.view];
        }];
    }
//    [self commitAply];
}

- (void)commitAply{
    if (!_isSecrecy) {
        [DDHub hub:@"请先阅读保密协议" view:self.view];
        return;
    }
    
    if (!_isPromise) {
        [DDHub hub:@"请先阅读服务承诺" view:self.view];
        return;
    }
    [DDHub hub:self.view];
    @weakify(self)
    [[DDUserManager share] setCurrenUserType:self.applyType
                                  completion:^(BOOL suc , NSString * message) {
                                      @strongify(self)
                                      if (!self) return ;
                                      if(suc) {
                                          [DDHub hub:@"申请成功" view:self.view];
                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                              [[NSNotificationCenter defaultCenter] postNotificationName:DD_GOTO_MAIN object:nil];
                                              [self.navigationController popViewControllerAnimated:YES];
                                          });
                                      }else {
                                          [DDHub hub:message view:self.view];
                                      }
                                  }];
}

- (IBAction)agreeButtonDidClick:(UIButton *)sender {
    DDProductAgreeServiceVc * vc = [DDProductAgreeServiceVc new];
    vc.url = sender.tag == 0 ? [NSString stringWithFormat:@"%@:%@/supervisor/manager/userPromiseDetail",DDAPP_URL,DDPort8003] : [NSString stringWithFormat:@"%@:%@/supervisor/manager/userSecrecyDetail",DDAPP_URL,DDPort8003];
    vc.serviceName = sender.tag == 0 ? @"服务承诺" : @"保密协议";
    @weakify(self)
    vc.argeeServiceBlock = ^(BOOL agree) {
        @strongify(self)
        if (!self) return ;
        if (sender.tag == 1) {
            self->_isSecrecy = agree;
            self.iconView1.image = [UIImage imageNamed:@"icon_order_selected"];
            self.descLb1.attributedText = [self getAttText:@"我已仔细阅读并同意" textLas:@"《保密协议》"];
        }else {
            self->_isPromise = agree;
            self.iconView2.image = [UIImage imageNamed:@"icon_order_selected"];
            self.descLb2.attributedText = [self getAttText:@"我已仔细阅读并同意" textLas:@"《服务承诺》"];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
