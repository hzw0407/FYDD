//
//  DDAppNetwork.h
//  FYDD
//
//  Created by mac on 2019/3/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

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

