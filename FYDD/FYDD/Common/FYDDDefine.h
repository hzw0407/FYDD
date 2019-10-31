//
//  FYDDDefine.h
//  FYDD
//
//  Created by mac on 2019/2/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#ifndef FYDDDefine_h
#define FYDDDefine_h

//首页新版本引导是否点击了
#define Home_FirstClick @"Home_FirstClick"
//身份主页新版本引导是否点击了
#define Identity_FirstClick @"Identity_FirstClick"
//百万计划新版本引导是否点击了
#define BW_FirstClick @"BW_FirstClick"
//商机新版本引导是否点击了
#define SJ_FirstClick @"SJ_FirstClick"

// Blugly
#define BuglyAppId @"bcd5be4ef5"
#define BuglyAppKey @"80640349-6bec-4d00-a8a7-58cc53a7e1ec"


// NotifycationKey
// LOGIN
#define DD_LOGIN_NOTE @"DD_LOGIN_NOTE"
#define DD_GOTO_MAIN @"DD_GOTO_MAIN"
#define iPhoneXAfter (kScreenSize.height > 736)
#define YYFormat(value1,value2)     ([NSString stringWithFormat:@"%@%@",value1,value2])
#define isiPhoneX [UIScreen mainScreen].bounds.size.height >= 812 ? YES : NO
#define NavigationHeight isiPhoneX ? 88 : 64


typedef void(^DDInputCellTextChange)(NSString * text, NSIndexPath * indexPath);
typedef void(^DDInputTextBlock)(NSString * text);
typedef void(^DDInputTextKeyBlock)(NSString * text,NSInteger key);
typedef void(^DDcommitButtonBlock)(void);
typedef void(^DDcommitButtonValueBlock)(NSInteger index);

typedef NS_ENUM(NSUInteger , DDUserType) {
    DDUserTypeSystem = 1, // 企业用户
    DDUserTypeOnline, // 实施方
    DDUserTypePromoter, // 代理方
   
};

// 支付方式
typedef NS_ENUM(NSUInteger , DDAppPayType) {
    DDAppPayTypeAlipay = 1,
    DDAppPayTypeWechat = 1 << 1,
    DDAppPayTypeWallet = 1 << 2,
    DDAppPayTypeBank = 1 << 3,
};

// 订单状态
typedef NS_ENUM(NSUInteger,DDOrderStatus){
    DDOrderStatusCancel,
    DDOrderStatusWaitCommit,
    DDOrderStatusCreate,
    DDOrderStatusPaySuccess,//支付成功
    DDOrderStatusPay, // 021支付中
    DDOrderStatusPayFail,
    DDOrderStatusLeaflets, // 030派单中
    DDOrderStatusOrderTaking, // 当前上线员接单
    DDOrderStatusService,
    DDOrderStatusCarry, // 050实施中
    DDOrderStatusChangeCarryUser, // 更换实施中
    DDOrderStatusWaitComment, // 待评价
    DDOrderStatusWaitPay,
    DDOrderStatusFinish,
    DDOrderWaitReceipt //待接单
};


// ShareSDK
#define DD_Share_SDK_Key @"2a969f82c7920"
#define SD_Share_SDK_Secret @"1a44799e3d7597aec68da98b27367d6a"

// 微信登录
#define DD_Wechat_key @""
#define DD_Wechat_secret @""

//appScheme
#define DDAppScheme @"fy3tzz"

#define AlipayNotifyCationKey @"AlipayNotify"
#define WechatNotifyCationKey @"WechatNotify"

#endif /* FYDDDefine_h */
