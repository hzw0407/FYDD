//
//  DDAppNetwork.h
//  FYDD
//
//  Created by mac on 2019/3/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

// 1期接口基地址
//#define DDAPP_URL @"http://app.3tmall.com"
#define DDAPP_URL @"http://47.107.166.105"
#define DDPort7001 @"7001"
#define DDPort8003 @"8003"

// 二期接口地址
#define DDAPP_2T_URL @"http://47.107.166.105:8004"

@interface DDAppNetwork : NSObject

+ (instancetype)share;

- (void)get:(BOOL)get
       path:(NSString *)path
 parameters:(NSDictionary *)parameters
 completion:(void (^)(NSInteger code,
                      NSString * message,
                      id data))competion;

- (void)get:(BOOL)get
       url:(NSString *)url
 parameters:(NSDictionary *)parameters
 completion:(void (^)(NSInteger code,
                      NSString * message,
                      id data))competion;

- (void)get:(BOOL)get
        url:(NSString *)url
       body:(NSString *)bodyText
 completion:(void (^)(NSInteger code,
                      NSString * message,
                      id data))competion;


- (void)get:(BOOL)get
       path:(NSString *)path
       body:(NSString *)body
 completion:(void (^)(NSInteger code,
                      NSString * message,
                      id data))competion;

- (void)path:(NSString *)path
      upload:(UIImage *)image
  completion:(void (^)(NSInteger code,
                       NSString * message,
                       id data))competion;

// 版本管理
- (void)checkAppVersion:(void (^)(void))competion isShowAll:(BOOL)isShowAll;
@end

