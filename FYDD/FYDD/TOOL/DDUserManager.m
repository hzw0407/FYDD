//
//  DDUserManager.m
//  FYDD
//
//  Created by mac on 2019/2/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDUserManager.h"
#import <JPush/JPUSHService.h>

@implementation DDUserManager

+ (instancetype)share{
    static dispatch_once_t onceToken;
    static DDUserManager * _manager;
    dispatch_once(&onceToken, ^{
       DDUserManager * user =  (DDUserManager*)[[DDAppManager share].cache objectForKey:@"DDUserManagerKey"];
        if (!user) {
            _manager = [[self alloc] init];
        }else {
            _manager = user;
        }
    });
    return _manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

// 保存y
- (void)save{
    // 如果登录了设置下别名
    if(_isLogged) {
        [JPUSHService setAlias:_user.userId
                    completion:^(NSInteger iResCode,
                                 NSString *iAlias,
                                 NSInteger seq) {
            
        } seq:1];
        
        [[DDAppNetwork share] get:YES
                             path:[NSString stringWithFormat:@"/uas/user/setAlias?token=%@&alias=%@",_user.token,_user.userId]
                             body:@""
                       completion:^(NSInteger code, NSString *message, id data) {
               
                       }];
    }
    [[DDAppManager share].cache setObject:self forKey:@"DDUserManagerKey" ];
}

- (void)clean{
    _isLogged = NO;
    [[DDAppManager share].cache removeObjectForKey:@"DDUserManagerKey"];
}




- (void)getUserInfo:(void (^)(void))competion{
    if (!_isLogged) return;
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/uas/user/user/userInfo/getUserInfo?token=",_user.token)
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (code == 200) {
                           DDUser * user = [DDUser modelWithJSON:data];
                           self.user.nickname = data[@"nickname"];
                           self.user.userHeadImage = data[@"userHeadImage"];
                           NSString * sex = [NSString stringWithFormat:@"%@",data[@"sex"]];
                           if ( [sex intValue] != -1) {
                              self.user.sex = [sex intValue] == 1 ? @"男" : @"女";
                           }
                           self.user.isOnlineUser = data[@"isOnlineUser"];
                           self.user.area = data[@"area"];
                           self.user.phone = data[@"phone"];
                           self.user.email = data[@"email"];
                           self.user.realAuthentication = [data[@"realAuthentication"] integerValue];
                           self.user.enterpriseName = data[@"enterpriseName"];
                           self.user.enterpriseAuthentication = [data[@"enterpriseAuthentication"] integerValue];
                           self.user.industry = data[@"industry"];
                           NSString * enterprise = [NSString stringWithFormat:@"%@",data[@"enterprise"]];
                           self.user.enterprise = [enterprise integerValue];
                           self.user.isFinishInfo = user.isFinishInfo;
                           self.user.totalScore = [[NSString stringWithFormat:@"%@",data[@"totlaScore"]] doubleValue];
                           self.user.wechatOpenid = user.wechatOpenid;
                           self.user.isAutoRenew = user.isAutoRenew;
                           self.user.onlineName = user.onlineName;
                           self.user.promoteOnline = yyTrimNullText(user.promoteOnline);
                           self.user.contractImgPath = user.contractImgPath;
                           self.user.qualificationNo = user.qualificationNo;
                           self.user.qualificationNoEx = user.qualificationNoEx;
                           self.user.isFinishPwd = user.isFinishPwd;
                           self.user.extensionName = data[@"extensionMember"];

                           if (yyTrimNullText(data[@"isAuth"]).length == 0) {
                               self.user.isAuth = -10;
                           }else {
                               self.user.isAuth = user.isAuth;
                           }
                           
                           self.user.userType = user.userType;
                           if (yyTrimNullText(data[@"isExtensionUser"]).length == 0) {
                               self.user.isExtensionUser = -10;
                           }else {
                               self.user.isExtensionUser = [[NSString stringWithFormat:@"%@",data[@"isExtensionUser"]] integerValue];
                           }
                           self.user.extensionTotalScore = data[@"extensionTotalScore"];
                           [self save];
                       }
                       if (competion) competion();
                   }];
}

- (NSString *)userPlaceImage{
    switch (_user.userType) {
        case DDUserTypeOnline:
            return @"icon_user_type2";
            break;
        case DDUserTypeSystem:
            return @"icon_user_type1";
            break;
        case DDUserTypePromoter:
            return @"icon_user_type3";
            break;
            
        default:
            return @"icon_user_type1";
            break;
    }
}


// 切换用户身份
- (void)setCurrenUserType:(DDUserType)type completion:(void (^) (BOOL suc, NSString *message))completion{
    NSString * url = [NSString stringWithFormat:@"/uas/user/user/userInfo/switchUserIdentity?token=%@&userType=%zd",_user.token,type];
    
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:url
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           if (!data || ![data isKindOfClass:[NSDictionary class]]){
                               if (completion)
                                   completion(code == 200,message);
                               return;
                           }
                           DDUser * user = [DDUserManager share].user;
                           user.userHeadImage = data[@"userAvatar"];
                           user.name = data[@"name"];
                           user.nickname = data[@"nickname"];
                           switch (type) {
                               case DDUserTypePromoter:{
                                   user.extensionName = yyTrimNullText(data[@"extensionName"]);
                                   user.extensionCode = yyTrimNullText(data[@"extensionCode"]);
                               }break;
                                   
                               case DDUserTypeSystem:{
                                   user.enterpriseName = yyTrimNullText(data[@"enterpriseName"]);
                                   user.userType = type;
                               }break;
                                   
                               case DDUserTypeOnline:{
                                   user.onlineName = yyTrimNullText(data[@"onlineName"]);
                                   NSString * totalScore = [NSString stringWithFormat:@"%@",data[@"totalScore"]];
                                   user.totalScore = [totalScore doubleValue];
                                   user.userType = type;
                                   break;
                               }default:
                                   break;
                           }
                           [self save];
                       }
                       if (completion)
                           completion(code == 200,message);
                   }];
}

- (void)getUserPayPasswordStateCompletion:(void (^) (BOOL suc))completion{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/uas/user/user/userInfo/payPasswordIsNull?token=", _user.token)
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       BOOL suc = NO;
                       if (code == 200) {
                           NSInteger objec = [data[@"isNull"] integerValue];
                           if (objec == 2) {
                               suc = YES;
                           }
                       }
                       if (completion)
                           completion(suc);
                   }];
}

- (void)logout:(void (^)(BOOL suc))competion{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/uas/user/user/login/logout?token=", _user.token)
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       BOOL suc = NO;
                       if (code == 200) {
                           suc = YES;
                       }
                       if (competion)
                           competion(suc);
                   }];
}

- (DDUser *)user {
    if (!_user) {
        return [DDUser new];
    }
    return _user;
}
@end

@implementation DDUser
- (NSString *)token{
    if (!_token) {
        return @"";
    }
    return _token;
}

@end
