//
//  AppDelegate.m
//  FYDD
//
//  Created by mac on 2019/2/20.
//  Copyright © 2019 www.sante.com. All rights reserved.

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import <Bugly/Bugly.h>
#import "FYDDDefine.h"
#import "FYSTHomeVc.h"
#import "DDWelcomeVC.h"
#import "DDLoginVC.h"
#import <UMCommon/UMCommon.h>
#import <AlipaySDK/AlipaySDK.h>
#import <UMShare/UMShare.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import <JPush/JPUSHService.h>
#import <UserNotifications/UserNotifications.h>
#import "DDAlertView.h"
#import <RNCachingURLProtocol/RNCachingURLProtocol.h>
#import "DDTabBarC.h"
#import "FYSTHomeVc.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = (YYScreenSize().height /  900) * 210;
    [IQKeyboardManager sharedManager].enable = true;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = true;
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    [self setupNavgationBar];
    
    [Bugly startWithAppId:BuglyAppId];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoLoginVC) name:DD_LOGIN_NOTE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMainVC) name:DD_GOTO_MAIN object:nil];
    
    [self setupShareSDK];
    
    [UMConfigure initWithAppkey:@"5cb5882f0cafb2ff12000488" channel:@"App Store"];
    
    // 登录
    if ([DDAppManager share].isShowWelcome) {
        [self gotoWelcomeVC];
    }else {
        if ([DDUserManager share].isLogged ||
            [DDUserManager share].isVisitorUser){
            [self gotoMainVC];
        }else {
            [self gotoLoginVC];
        }

    }
    
    [WXApi registerApp:@"wx8e0c9b84d41edb60"];
    
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx8e0c9b84d41edb60" appSecret:@"c2a9347f595f514cbe81089aad8b00cf" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1141013720"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
   
    [[AipOcrService shardService] authWithAK:@"Laetmw8BqNSaiMOKhNbGLWcn" andSK:@"HuOeREIpCUoLIUhC2D684gfY2lQiRdOI"];
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"4ac2cc35512129df65351b53"
                          channel:@"app store"
                 apsForProduction:YES];
    
 

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    if (@available(iOS 11.0, *)) {
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (launchOptions) {
         [self gotoMessageVc:@""];
    }
    return YES;
}


- (void)gotoWelcomeVC {
     self.window.rootViewController = [DDWelcomeVC new];
}

- (void)gotoLoginVC {
     self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[DDLoginVC new]];
}

- (void)gotoMainVC {
    // 当前的身份
//    if ([DDUserManager share].user.userType == DDUserTypeSystem) {
//        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[FYSTHomeVc new]];
//    }else {
//        self.window.rootViewController = [DDTabBarC new];
//    }
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[FYSTHomeVc new]];
    
}

- (void)setupShareSDK {
    

}

- (void)setupNavgationBar{
    UINavigationBar * appearanceBar = [UINavigationBar appearance];
    appearanceBar.translucent = NO;
    appearanceBar.tintColor = [UIColor blackColor];
    appearanceBar.barTintColor =  [UIColor whiteColor];
    [appearanceBar setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : UIColorHex(0x193750),
                                            }];
    UIBarButtonItem *barItem =[UIBarButtonItem appearance];
    NSDictionary *barItemTextAttr = @{
                                      NSForegroundColorAttributeName : [UIColor blackColor],
                                      NSFontAttributeName : [UIFont systemFontOfSize:15],
                                      };
    [barItem setBackButtonTitlePositionAdjustment:(UIOffsetMake(-2000, 0)) forBarMetrics:(UIBarMetricsDefault)];
    
    [barItem setTitleTextAttributes:barItemTextAttr forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:barItemTextAttr forState:UIControlStateHighlighted];
    
    
    UITabBar * tabBar = [UITabBar appearance];
    tabBar.translucent = NO;
    tabBar.tintColor = UIColorHex(0x2996EB);
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                      standbyCallback:^(NSDictionary *resultDic) {
                                                          NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [[NSNotificationCenter defaultCenter] postNotificationName:AlipayNotifyCationKey
                                                                                                                  object:@(resultStatus)];
                                                          });
                                                      }];
        }else {
            return [WXApi handleOpenURL:url delegate:self];
        }
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url ];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                      standbyCallback:^(NSDictionary *resultDic) {
                                                          NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [[NSNotificationCenter defaultCenter] postNotificationName:AlipayNotifyCationKey
                                                                                                                  object:@(resultStatus)];
                                                          });
                                                      }];
        }else {
            return [WXApi handleOpenURL:url delegate:self];
        }
    }
    return YES;
}


-(void) onResp:(BaseResp*)resp{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        [[NSNotificationCenter defaultCenter] postNotificationName:WechatNotifyCationKey
                                                            object:@(resp.errCode)];
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
    }
    [self gotoMessageVc:userInfo[@"requestUrl"]];
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


// 消息推送
- (void)gotoMessageVc:(NSString *)url{
    if (![DDUserManager share].isLogged || self->_gotoPush) {
        return;
    }
    _gotoPush = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       self->_gotoPush = NO;
                       /*
                            [self->_mainVc gotoMessageVc:url];
                        */
    });
    
}


@end
