//
//  STHttpRequestManager.h
//  FYDD
//
//  Created by 何志武 on 2019/10/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessRequestBlock)(NSDictionary *dict);
typedef void(^FailRequestBlock)(NSURLSessionDataTask *task, NSError *error);

typedef NS_ENUM(NSInteger, RequestType){
    RequestGet = 0,//get请求
    RequestPost,//post请求
    RequestPut,//put请求
    RequestDelete,//delete请求
} ;

@interface STHttpRequestManager : NSObject

//单例
+ (STHttpRequestManager *)shareManager;

/**
 请求参数

 @param key key
 @param value value
 */
- (void)addParameterWithKey:(NSString *)key withValue:(id)value;

/**
 网络请求

 @param url 请求url
 @param type 请求类型
 @param successBlock 成功块
 @param failBlock 失败块
 */
- (void)requestDataWithUrl:(NSString *)url
                  withType:(RequestType)type
               withSuccess:(SuccessRequestBlock)successBlock
                  withFail:(FailRequestBlock)failBlock;

@end

NS_ASSUME_NONNULL_END
