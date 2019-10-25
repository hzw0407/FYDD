//
//  STHttpRequestManager.m
//  FYDD
//
//  Created by 何志武 on 2019/10/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "STHttpRequestManager.h"

@interface STHttpRequestManager ()

@property (nonatomic, strong) NSMutableDictionary *parametersDic;

@end

static AFHTTPSessionManager *sessionManager;

@implementation STHttpRequestManager

+ (STHttpRequestManager *)shareManager{
    static STHttpRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[STHttpRequestManager alloc] init];
    });
    return manager;
}

//网络请求管理者单例划，
+ (AFHTTPSessionManager *)shareSessionManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [AFHTTPSessionManager manager];
        //设置请求参数类型
        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        //设置服务器返回数据类型
        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        //设置请求超时时间
        sessionManager.requestSerializer.timeoutInterval = 60.0f;
        //设置ContentType
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/jpeg",@"image/png", nil];
    });
    return sessionManager;
}

/**
 请求参数
 
 @param key key
 @param value value
 */
- (void)addParameterWithKey:(NSString *)key withValue:(id)value{
    id tempValue = [self.parametersDic valueForKey:key];
    if (tempValue != value) {
        [self.parametersDic setValue:value forKey:key];
    }
    
}

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
                  withFail:(FailRequestBlock)failBlock{
    
    //创建会话管理者
    AFHTTPSessionManager *manager = [STHttpRequestManager shareSessionManager];
    //设置请求参数类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置服务器返回数据类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //设置请求超时时间
    manager.requestSerializer.timeoutInterval = 60.0f;
    //设置ContentType
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/jpeg",@"image/png", nil];
    
    if (type == RequestGet) {
        [manager GET:url parameters:self.parametersDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self.parametersDic removeAllObjects];
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                successBlock(responseObject);
            }else if ([responseObject isKindOfClass:[NSData class]]){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                successBlock(dic);
            }else{
                successBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failBlock(task,error);
            
        }];
    }else if (type == RequestPost){
        [manager POST:url parameters:self.parametersDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self.parametersDic removeAllObjects];
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                successBlock(responseObject);
            }else if ([responseObject isKindOfClass:[NSData class]]){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                successBlock(dic);
            }else{
                successBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failBlock(task,error);
            
        }];
    }else if (type == RequestPut){
        [manager PUT:url parameters:self.parametersDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self.parametersDic removeAllObjects];
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                successBlock(responseObject);
            }else if ([responseObject isKindOfClass:[NSData class]]){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                successBlock(dic);
            }else{
                successBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failBlock(task,error);
            
        }];
    }else if (type == RequestDelete){
        [manager DELETE:url parameters:self.parametersDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            [self.parametersDic removeAllObjects];
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                successBlock(responseObject);
            }else if ([responseObject isKindOfClass:[NSData class]]){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                successBlock(dic);
            }else{
                successBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            failBlock(task,error);
            
        }];
    }
    
}

- (NSMutableDictionary *)parametersDic{
    if (!_parametersDic) {
        _parametersDic = [NSMutableDictionary dictionary];
    }
    return _parametersDic;
}

@end
