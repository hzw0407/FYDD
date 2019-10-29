//
//  DDAppManager.h
//  FYDD
//
//  Created by mac on 2019/2/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYCache.h>

@interface DDAppManager : NSObject
// 颜色
@property (nonatomic,strong,readonly) UIColor * navigationBarBgColor;
@property (nonatomic,strong,readonly) UIColor * appTintColor;
@property (nonatomic,strong,readonly) UIColor * navigationTintColor;

// 是否第一次进入App
@property (nonatomic,assign,readonly) BOOL isShowWelcome;

// 缓存
@property (nonatomic,strong) YYCache * cache;

// 跳转
+ (void)gotoVC:(UIViewController *)vc navigtor:(UINavigationController *)nav;

+ (void)popVc:(NSString *)targetClass navigtor:(UINavigationController *)nav;

+ (void)gotoVC:(UIViewController *)vc navigtor:(UINavigationController *)nav animated:(BOOL)animated;
// 分享
+ (void)share:(NSString *)code
        title:(NSString *)title
       remark:(NSString*)remark
    iconImage:(NSString *)image;

+ (instancetype)share;

- (NSString *)getCityCode:(NSString *)code;
- (NSString *)getCityNameWithCode:(NSString *)name;

@end


extern NSString * yyTrimNullText(NSString *text);
extern DDOrderStatus convertOrderStatus(NSString *status,NSInteger isCompanyFirst);
