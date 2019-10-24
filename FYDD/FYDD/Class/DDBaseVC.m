//
//  DDBaseVC.m
//  FYDD
//
//  Created by mac on 2019/4/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDBaseVC.h"
#import "DDLoginVC.h"
#import "DDEditUserVC.h"
@interface DDBaseVC ()

@end

@implementation DDBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""]  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.tintColor = [DDAppManager share].navigationTintColor;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : UIColorHex(0x193750),
                                                                      }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:true];
}

- (void)checkLoginStatus:(void (^)(BOOL isLogged))block{
    if ([DDUserManager share].isLogged) {
        if (block) block(YES);
    }else {
        if (block) block(NO);
        DDLoginVC * loginVc = [DDLoginVC new];
        loginVc.isCheckEnter = YES;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVc]
                           animated:YES
                         completion:^{
                             
                         }];
    }
}

- (void)login:(BOOL)animated{
    DDLoginVC * loginVc = [DDLoginVC new];
    loginVc.isCheckEnter = YES;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVc]
                       animated:NO
                     completion:^{
                         
                     }];
}

- (void)checkUserInfo:(void (^)(BOOL finish))block{
    if ([DDUserManager share].isLogged) {
            @weakify(self)
            [[DDUserManager share] getUserInfo:^{
                if (block) block(YES);
                if ([DDUserManager share].user.isFinishInfo != 0) {
                    @strongify(self)
                    DDEditUserVC * vc = [DDEditUserVC new];
                    vc.wechart = [DDUserManager share].user.isFinishInfo == 2;
                    vc.isCheckEnter = YES;
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]
                                       animated:YES
                                     completion:^{
                                         
                                     }];
                }
               
            }];
    }
}

@end
