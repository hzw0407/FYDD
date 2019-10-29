//
//  DDProfileVC.m
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProfileVC.h"
#import <CWLateralSlide/UIViewController+CWLateralSlide.h>
#import "DDUserInfoVC.h"
#import "DDWalletVC.h"
#import "DDJuniorVC.h"
#import "DDShareVC.h"
#import "DDChangeUserTypeVC.h"
#import "DDClerkVerifyVC.h"
#import "DDUserComanyInfoVC.h"
#import "DDSettingVC.h"
#import "DDOrderVC.h"
#import "DDContactListVC.h"
#import "DDAuthenticationIdCardVcView.h"
#import "DDLADetailVc.h"
#import "DDLADetailVc.h"
#import "DDAuthenVc.h"
#import "DDOnlineStudyVc.h"

@interface DDProfileVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons;

@property (weak, nonatomic) IBOutlet UIButton *nameLb;//名称
@property (weak, nonatomic) IBOutlet UIButton *descLb;//企业认证信息

@property (weak, nonatomic) IBOutlet UIButton *onelineBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userIconView;

@property (weak, nonatomic) IBOutlet UIImageView *iconTipView;
@property (weak, nonatomic) IBOutlet UIImageView *iconTipView1;
@property (weak, nonatomic) IBOutlet UIImageView *iconTipView2;

@property (weak, nonatomic) IBOutlet UIButton *verifyCodeButton;//实施方证书
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeButton1;//代理方证书

@property (weak, nonatomic) IBOutlet UIButton *studyButton;
@end

@implementation DDProfileVC

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _descLb.titleLabel.numberOfLines = 0;
}

// 证书点击
- (IBAction)verifyCodeButtonDidClick:(UIButton *)sender {
    DDLADetailVc * vc = [DDLADetailVc new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userType = [DDUserManager share].user.userType;
    [self cw_pushViewController:vc];
}

- (IBAction)buttonDidClick:(UIButton *)sender {
    if (sender.tag == 0) {
        // 订单
        DDOrderVC * vc = [DDOrderVC new];
//        if ([DDUserManager share].user.userType == DDUserTypeOnline) {
//            vc.title = @"实施方";
//        }else if ([DDUserManager share].user.userType == DDUserTypeSystem) {
//            vc.title = @"订单";
//        }else {
//            vc.title = @"代理方";
//        }
        vc.type = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self cw_pushViewController:vc];
    }else if (sender.tag == 1) {
        //企业
        if ([DDUserManager share].user.realAuthentication != 1) {
            //未实名认证
            DDAuthenticationIdCardVcView * vc = [DDAuthenticationIdCardVcView new];
            vc.hidesBottomBarWhenPushed = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [DDHub hub:@"未实名认证，请先认证" view:vc.view];
            });
            [self cw_pushViewController:vc];
        }else {
            if ([DDUserManager share].user.isAuth == 1) {
                //已企业认证
                DDLADetailVc * vc = [DDLADetailVc new];
                vc.userType = DDUserTypeOnline;
                vc.hidesBottomBarWhenPushed = YES;
                [self cw_pushViewController:vc];
            }else {
                //未企业认证
                DDAuthenVc * vc = [DDAuthenVc new];
                vc.hidesBottomBarWhenPushed = YES;
                [self cw_pushViewController:vc];
            }
        }
//        switch ([DDUserManager share].user.userType) {
//            case DDUserTypeOnline:{
//                //个人认证没认证
//                if ([DDUserManager share].user.realAuthentication != 1){
//                    DDAuthenticationIdCardVcView * vc = [DDAuthenticationIdCardVcView new];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [DDHub hub:@"未实名认证，请先认证" view:vc.view];
//                    });
//                    [self cw_pushViewController:vc];
//                }else {
//                    if ([DDUserManager share].user.isAuth == 1) {
//                        DDLADetailVc * vc = [DDLADetailVc new];
//                        vc.userType = DDUserTypeOnline;
//                        vc.hidesBottomBarWhenPushed = YES;
//                        [self cw_pushViewController:vc];
//                    }else {
//                        DDAuthenVc * vc = [DDAuthenVc new];
//                        vc.hidesBottomBarWhenPushed = YES;
//                        [self cw_pushViewController:vc];
//                    }
//
//                }
//
//            }break;
//
//            case DDUserTypeSystem:{
//                DDUserComanyInfoVC * vc = [DDUserComanyInfoVC new];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self cw_pushViewController:vc];
//            }break;
//
//            case DDUserTypePromoter:{
//                DDJuniorVC * vc = [DDJuniorVC new];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self cw_pushViewController:vc];
//            }break;
//            default:
//                break;
//        }
    }else if (sender.tag == 2) {
        //报名
        DDAuthenVc *vc = [[DDAuthenVc alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self cw_pushViewController:vc];
    }else if (sender.tag == 3) {
        // 钱包
        DDWalletVC * vc = [DDWalletVC new];
        vc.hidesBottomBarWhenPushed = YES;
        [self cw_pushViewController:vc];
    }else if (sender.tag == 4) {
        // 客服
        DDContactListVC * vc = [DDContactListVC new];
        vc.hidesBottomBarWhenPushed = YES;
        [self cw_pushViewController:vc];
    }else if (sender.tag == 5) {
        // 设置
        DDSettingVC * vc = [DDSettingVC new];
        vc.hidesBottomBarWhenPushed = YES;
        [self cw_pushViewController:vc];
    }else if (sender.tag == 6) {
        //在线学习
        DDOnlineStudyVc *vc = [DDOnlineStudyVc new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userType = [DDUserManager share].user.userType == DDUserTypePromoter ? DDUserTypeOnline :  DDUserTypePromoter;
        [self cw_pushViewController:vc];
    }else if (sender.tag == 7) {
        //我的代理码
        DDShareVC * vc = [DDShareVC new];
        vc.hidesBottomBarWhenPushed = YES;
        [self cw_pushViewController:vc];
    }else if (sender.tag == 8) {
        //个人信息
        DDUserInfoVC *vc = [[DDUserInfoVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self cw_pushViewController:vc];
    }
//    else if (sender.tag == 5) {
    //切换身份
//        DDChangeUserTypeVC * vc = [DDChangeUserTypeVC new];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self cw_pushViewController:vc];
//    // 二维码
//    }else if (sender.tag == 6) {
//        DDShareVC * vc = [DDShareVC new];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self cw_pushViewController:vc];
//    // 个人信息
//    }else {
//        DDUserInfoVC * vc = [DDUserInfoVC new];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self cw_pushViewController:vc];
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
    @weakify(self)
    [[DDUserManager share] getUserInfo:^{
        @strongify(self)
        if (!self) return ;
        [self updateUI];
    }];
    
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/fps/wallet/getHavChange?token=", [DDUserManager share].user.token)
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           self.iconTipView.hidden = ![yyTrimNullText(data[@"order"]) boolValue];
                           self.iconTipView1.hidden = ![yyTrimNullText(data[@"wallet"]) boolValue];
                           self.iconTipView2.hidden = ![yyTrimNullText(data[@"chat"]) boolValue];
                       }
                   }];

}

- (void)updateUI{
    DDUser * user = [DDUserManager share].user;
//    switch (user.userType) {
//            // 实施方
//        case DDUserTypeOnline:{
//            [_nameLb setTitle:yyTrimNullText(user.nickname) forState:UIControlStateNormal];
//            [_descLb setTitle:[NSString stringWithFormat:@"实施方  %.1f分",user.totalScore] forState:UIControlStateNormal];
//            [_onelineBtn setTitle:@"认证" forState:UIControlStateNormal];
//            [_onelineBtn setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
//            _verifyCodeButton.hidden = !user.isAuth;
//            [_studyButton setTitle:@"在线学习" forState:UIControlStateNormal];
//            [_studyButton setImage:[UIImage imageNamed:@"icon_study"] forState:UIControlStateNormal];
//        }break;
//            // 企业用户
//        case DDUserTypeSystem:
//            [_studyButton setTitle:@"切换身份" forState:UIControlStateNormal];
//            [_studyButton setImage:[UIImage imageNamed:@"icon_exchange"] forState:UIControlStateNormal];
//            [_nameLb setTitle:yyTrimNullText(user.nickname) forState:UIControlStateNormal];
//            [_descLb setAttributedTitle:nil forState:UIControlStateNormal];
//            [_descLb setTitle:user.enterpriseAuthentication == 1 ? yyTrimNullText(user.enterpriseName): @"未认证企业" forState:UIControlStateNormal];
//            [_onelineBtn setTitle:@"企业" forState:UIControlStateNormal];
//            [_onelineBtn setImage:[UIImage imageNamed:@"company"] forState:UIControlStateNormal];
//            break;
//            // 代理方
//        case DDUserTypePromoter:
//            [_nameLb setTitle:yyTrimNullText(user.nickname) forState:UIControlStateNormal];
//            [_descLb setTitle:[NSString stringWithFormat:@"代理方  %.1f分",[yyTrimNullText(user.extensionTotalScore) doubleValue]] forState:UIControlStateNormal];
//            [_onelineBtn setTitle:@"下线" forState:UIControlStateNormal];
//            [_onelineBtn setImage:[UIImage imageNamed:@"icon_profile4"] forState:UIControlStateNormal];
//            _verifyCodeButton.hidden = user.isExtensionUser != 1;
//             [_studyButton setTitle:@"在线学习" forState:UIControlStateNormal];
//             [_studyButton setImage:[UIImage imageNamed:@"icon_study"] forState:UIControlStateNormal];
//            break;
//
//        default:
//            break;
//    }
    [_nameLb setTitle:yyTrimNullText(user.nickname) forState:UIControlStateNormal];
    [_descLb setAttributedTitle:nil forState:UIControlStateNormal];
    [_descLb setTitle:user.enterpriseAuthentication == 1 ? yyTrimNullText(user.enterpriseName): @"未认证企业" forState:UIControlStateNormal];
    //证书
    if (user.isExtensionUser == 1 || user.isOnlineUser == 1) {
        //代理方或者实施方认证通过
        self.verifyCodeButton.hidden = NO;
        self.verifyCodeButton1.hidden = NO;
    }else if (user.isExtensionUser == 1 && user.isOnlineUser != 1) {
        //代理方认证通过，实施方没认证
        self.verifyCodeButton.hidden = YES;
        self.verifyCodeButton1.hidden = NO;
    }else if (user.isExtensionUser != 1 && user.isOnlineUser == 1) {
        //代理方没认证,实施方认证通过
        self.verifyCodeButton.hidden = NO;
        self.verifyCodeButton1.hidden = YES;
    }else {
        //代理方和实施方都没认证
        self.verifyCodeButton.hidden = YES;
        self.verifyCodeButton1.hidden = YES;
    }
    //代理码
    UIButton *delegateCodebutton = [self.view viewWithTag:7];
    if (user.isExtensionUser == 0) {
        //未认证代理方
        delegateCodebutton.hidden = YES;
    }else {
        //认证了代理方
        delegateCodebutton.hidden = NO;
    }
    NSString * iconURL = yyTrimNullText(user.userHeadImage);
    if ([iconURL hasPrefix:@"http"]) {
        [_userIconView sd_setImageWithURL:[NSURL URLWithString:iconURL]];
    }else {
        _userIconView.image = [UIImage imageNamed:[DDUserManager share].userPlaceImage];
    }
}


- (IBAction)studyButtonDidClick:(UIButton *)sender {
//    if ([DDUserManager share].user.userType == DDUserTypeSystem) {
////        [self buttonDidClick:_checkButton];
//    }else {
//        DDOnlineStudyVc *vc = [DDOnlineStudyVc new];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.userType = [DDUserManager share].user.userType == DDUserTypePromoter ? DDUserTypeOnline :  DDUserTypePromoter;
//        [self cw_pushViewController:vc];
//    }
    
    DDOnlineStudyVc *vc = [DDOnlineStudyVc new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userType = [DDUserManager share].user.userType == DDUserTypePromoter ? DDUserTypeOnline :  DDUserTypePromoter;
    [self cw_pushViewController:vc];

}

@end
