//
//  STTool.h
//  FYDD
//
//  Created by 何志武 on 2019/10/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STTool : NSObject

/// 十六进制转颜色
/// @param hexColor 十六进制字符串
/// @param opacity 透明度
+ (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity;

@end

NS_ASSUME_NONNULL_END
