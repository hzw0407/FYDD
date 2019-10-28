//
//  DDUserManager.h
//  FYDD
//
//  Created by mac on 2019/2/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDEncodeObject.h"


// 用户信息
@interface DDUser : DDEncodeObject
@property (nonatomic,copy) NSString * email;
@property (nonatomic,assign) NSInteger enterprise;
@property (nonatomic,copy) NSString * enterpriseName;
@property (nonatomic,copy) NSString * qualificationNoEx;
@property (nonatomic,assign) BOOL  isCompanyUser;
@property (nonatomic,assign) NSInteger isFinishInfo;
@property (nonatomic,assign) NSInteger isOnlineUser;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,copy) NSString * promoteLnline;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,copy) NSString * token;
@property (nonatomic,copy) NSString * userHeadImage;
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) NSString * userName;
// 微信id
@property (nonatomic,copy) NSString * wechatOpenid;
@property (nonatomic,assign) DDUserType userType;

@property (nonatomic,copy) NSString * sex;
@property (nonatomic,copy) NSString * area;
@property (nonatomic,copy) NSString * cityname;
@property (nonatomic,assign) DDUserType isAutoRenew;
// isAutoRenew
// 身份证号码
@property (nonatomic,copy) NSString * idcard;

// 企业是否认证
@property (nonatomic,assign) NSInteger enterpriseAuthentication;
// 实名认证状态
@property (nonatomic,assign) NSInteger realAuthentication;
// 所在行业
@property (nonatomic,copy) NSString * industry;

// 代理方等级名称
@property (nonatomic,copy) NSString * extensionName;
// 代理方推广码
@property (nonatomic,copy) NSString * extensionCode;

// 实施方等级名称
@property (nonatomic,copy) NSString * onlineName;
// 实施方总和评分
@property (nonatomic,assign) double totalScore;

// 是否有密码了
@property (nonatomic,assign) NSInteger isFinishPwd;
// -1申请中，0:未认证，1:已通过;2:认证不通过,-10待申请
@property (nonatomic,assign) NSInteger isAuth;
// 代理方推广码
@property (nonatomic,copy) NSString * contractImgPath;
// 实施方等级名称
@property (nonatomic,copy) NSString * qualificationNo;

@property (nonatomic,copy) NSString * extensionTotalScore;
// 代理方认证状态 0 未认证 1 已认证 2 认证中  3 认证不通过,-10待申请
@property (nonatomic,assign) NSInteger isExtensionUser;

@property (nonatomic,copy) NSString * promoteOnline;
@end




@interface DDUserManager : DDEncodeObject
// 用户信息
@property (nonatomic,strong) DDUser * user;

// 用户默认头像
@property (nonatomic,copy) NSString * userPlaceImage;

// 是否登录
@property (nonatomic,assign) BOOL isLogged;

// 是不是体验用户
@property (nonatomic,assign) BOOL isVisitorUser;
// token失效了
@property (nonatomic,assign) BOOL tokenIsVaild;


+ (instancetype)share;

- (void)save;
- (void)clean;

// 获取个人信息
- (void)getUserInfo:(void (^)(void))competion;

// 切换用户身份
- (void)setCurrenUserType:(DDUserType)type completion:(void (^) (BOOL suc, NSString *message))completion;

// 判断用户是否设置了支付密码
- (void)getUserPayPasswordStateCompletion:(void (^) (BOOL suc))completion;

// 退出登录
- (void)logout:(void (^)(BOOL suc))competion;
@end




