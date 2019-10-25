//
//  STAdvertorialsModel.h
//  FYDD
//
//  Created by 何志武 on 2019/10/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STAdvertorialsModel : NSObject

@property (nonatomic, copy) NSString *titleImg;//图片
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *content;//内容链接
@property (nonatomic, assign) NSInteger browserNum;//浏览量
@property (nonatomic, assign) NSTimeInterval createTimeF;//创建时间
@property (nonatomic, copy) NSString *standby1;//内容
@property (nonatomic, copy) NSString *idStr;

@end

NS_ASSUME_NONNULL_END
