//
//  DDAppNetwork.m
//  FYDD
//
//  Created by mac on 2019/3/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDAppNetwork.h"
#import "DDAlertView.h"

@implementation DDAppNetwork
+ (instancetype)share{
    static dispatch_once_t onceToken;
    static DDAppNetwork * _manager;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (void)get:(BOOL)get
       path:(NSString *)path
 parameters:(NSDictionary *)parameters
 completion:(void (^)(NSInteger code,
                      NSString * message,
                      id data))competion {
    
    NSString *url = [NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort7001,path];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    void (^parseBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSMutableDictionary* json = [NSJSONSerialization
                                     JSONObjectWithData:responseObject
                                     options:NSJSONReadingMutableContainers
                                     error:nil];
        NSInteger code = [json[@"code"] intValue];
        NSString * message = json[@"message"];
        if(code  == 1000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DD_LOGIN_NOTE object:nil];
            [DDUserManager share].tokenIsVaild = YES;
        }else {
            if (competion)
                competion(code,message,json[@"data"]);
        }
    };
    
    if (get) {
        [manager GET:url
          parameters:parameters
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task,
                       id  _Nullable responseObject){
                 parseBlock(task,responseObject);
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 if (competion)
                     competion(404, @"网络错误",nil);
             }];
    }else {
        [manager POST:url
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task,
                        id  _Nullable responseObject) {
                  
             parseBlock(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task,
                    NSError * _Nonnull error) {
            if (competion)
                competion(404, @"网络错误",nil);
        }];
    }
}

- (void)get:(BOOL)get
        url:(NSString *)url
       body:(NSString *)bodyText
 completion:(void (^)(NSInteger code,
                      NSString * message,
                      id data))competion{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    void (^parseBlock)( NSData * _Nullable data) = ^( NSData * _Nullable data){
        NSMutableDictionary* json = [NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:NSJSONReadingMutableContainers
                                     error:nil];
        NSInteger code = [json[@"code"] intValue];
        NSString * message = json[@"message"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(code  == 1000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:DD_LOGIN_NOTE object:nil];
                [DDUserManager share].tokenIsVaild = YES;
            }else {
                if (competion)
                    competion(code,message,json[@"data"]);
            }
            
        });
    };
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = get ? @"GET" : @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[bodyText dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *dataTask = [manager.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (competion)
                    competion(404, @"网络错误",nil);
            });
        }else {
            parseBlock(data);
        }
    }];
    [dataTask resume];
}

- (void)get:(BOOL)get
        url:(NSString *)url
 parameters:(NSDictionary *)parameters
 completion:(void (^)(NSInteger code,
                      NSString * message,
                      id data))competion{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    void (^parseBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSMutableDictionary* json = [NSJSONSerialization
                                     JSONObjectWithData:responseObject
                                     options:NSJSONReadingMutableContainers
                                     error:nil];
        NSInteger code = [json[@"code"] intValue];
        NSString * message = json[@"message"];
        if(code  == 1000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DD_LOGIN_NOTE object:nil];
            [DDUserManager share].tokenIsVaild = YES;
        }else {
            if (competion)
                competion(code,message,json[@"data"]);
        }
    };
    
    if (get) {
        [manager GET:url
          parameters:parameters
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task,
                       id  _Nullable responseObject){
                 parseBlock(task,responseObject);
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 if (competion)
                     competion(404, @"网络错误",nil);
             }];
    }else {
        [manager POST:url
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task,
                        id  _Nullable responseObject) {
                  
                  parseBlock(task,responseObject);
              } failure:^(NSURLSessionDataTask * _Nullable task,
                          NSError * _Nonnull error) {
                  if (competion)
                      competion(404, @"网络错误",nil);
              }];
    }
}

- (void)get:(BOOL)get
       path:(NSString *)path
       body:(NSString *)body
 completion:(void (^)(NSInteger code,
                      NSString * message,
                      id data))competion{
    NSString *url = [NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort7001,path];
    NSLog(@"%@",url);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    void (^parseBlock)( NSData * _Nullable data) = ^( NSData * _Nullable data){
        NSMutableDictionary* json = [NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:NSJSONReadingMutableContainers
                                     error:nil];
        NSInteger code = [json[@"code"] intValue];
        NSString * message = json[@"message"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(code  == 1000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:DD_LOGIN_NOTE object:nil];
                [DDUserManager share].tokenIsVaild = YES;
            }else {
                if (competion)
                    competion(code,message,json[@"data"]);
            }
            
        });
    };
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = get ? @"GET" : @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *dataTask = [manager.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (competion)
                    competion(404, @"网络错误",nil);
            });
        }else {
            parseBlock(data);
        }
    }];
    [dataTask resume];
}

- (void)path:(NSString *)path upload:(UIImage *)image  completion:(void (^)(NSInteger code,
                                                                            NSString * message,
                                                                            id data))competion{
    NSString *url = [NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort7001,path];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"text/json",
                                                         @"text/plain",
                                                         nil];

    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
        [formData appendPartWithFileData:imageData name:@"fileUpload" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary* json = [NSJSONSerialization
                                     JSONObjectWithData:responseObject
                                     options:NSJSONReadingMutableContainers
                                     error:nil];
        NSInteger code = [json[@"code"] intValue];
        NSString * message = json[@"message"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(code  == 1000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:DD_LOGIN_NOTE object:nil];
                [[DDUserManager share] clean];
                [DDUserManager share].tokenIsVaild = YES;
            }else {
                if (competion)
                    competion(code,message,json[@"data"]);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (competion)
            competion(404, @"网络错误",nil);
        });
    }];
}

- (void)checkAppVersion:(void (^)(void))competion isShowAll:(BOOL)isShowAll{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self get:YES
             path:@"/uas/t/version/getIosVersion"
             body:@""
       completion:^(NSInteger code, NSString *message, id data) {
           if (code == 200) {
               NSString * version = data[@"vNumber"];
               NSString * downLoadURL =  data[@"vUrl"];
               BOOL vForcedUpdating = [yyTrimNullText(data[@"vForcedUpdating"]) boolValue];
               NSString * vUpdateContent = data[@"vUpdateContent"];
               if (!vUpdateContent) {
                   vUpdateContent = @"有新版本，是否更新";
               }
               NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
               NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
               // 有新版本
               if (![app_Version isEqualToString:version] && downLoadURL) {
                   if (vForcedUpdating) {
                       [DDAlertView showTitle:@"提示"
                                     subTitle:vUpdateContent
                                  cancelEvent:^{
                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downLoadURL]];
                       }];
                   }else {
                       [DDAlertView showTitle:@"提示"
                                     subTitle:vUpdateContent
                                    sureEvent:^{
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downLoadURL]];
                                    } cancelEvent:^{
                                        
                                    }];
                   }
               }else {
                   if (isShowAll) {
                       [DDAlertView showTitle:@"提示"
                                     subTitle:@"当前版本已是最新版本"
                                  cancelEvent:^{
                                  }];
                   }
               }
           }
       }];
    });

}
@end
