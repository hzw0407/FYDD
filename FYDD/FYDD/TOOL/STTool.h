//
//  STTool.h
//  FYDD
//
//  Created by 何志武 on 2019/10/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STHttpRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface STTool : NSObject

/// 十六进制转颜色
/// @param hexColor 十六进制字符串
/// @param opacity 透明度
+ (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity;

/// 动态计算高度
/// @param string 需要计算的字符串
/// @param fontSize 字体大小
/// @param width 宽度
+ (CGFloat)calculateHeight:(NSString *)string fontSize:(NSInteger)fontSize width:(CGFloat)width;

/// 动态计算宽度
/// @param string 需要计算的字符串
/// @param fontSize 字体大小
/// @param height 宽度
+ (CGFloat)calculateWidth:(NSString *)string fontSize:(NSInteger)fontSize height:(CGFloat)height;

/// 检查版本更新
/// @param successBlock 成功快
/// @param failBlock 失败快
+ (void)checkVersionWithSuccess:(SuccessRequestBlock)successBlock                withFail:(FailRequestBlock)failBlock;

@end

NS_ASSUME_NONNULL_END
