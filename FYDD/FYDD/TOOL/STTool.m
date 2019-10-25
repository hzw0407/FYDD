//
//  STTool.m
//  FYDD
//
//  Created by 何志武 on 2019/10/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "STTool.h"

@implementation STTool

/// 十六进制转颜色
/// @param hexColor 十六进制字符串
/// @param opacity 透明度
+ (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity{
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];

    if ([cString length] != 6) return [UIColor blackColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];

    range.location = 2;
    NSString * gString = [cString substringWithRange:range];

    range.location = 4;
    NSString * bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];
}


/// 动态计算高度
/// @param string 需要计算的字符串
/// @param fontSize 字体大小
/// @param width 宽度
+ (CGFloat)calculateHeight:(NSString *)string fontSize:(NSInteger)fontSize width:(CGFloat)width {
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};

    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin |  NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return ceilf(rect.size.height);;
    
}

/// 动态计算宽度
/// @param string 需要计算的字符串
/// @param fontSize 字体大小
/// @param height 宽度
+ (CGFloat)calculateWidth:(NSString *)string fontSize:(NSInteger)fontSize height:(CGFloat)height {
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};

    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin |  NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return ceilf(rect.size.height);;
    
}

/// 时间戳转时间
/// @param time 时间戳
+ (NSString *)getTimeFromTimestamp:(NSTimeInterval)time{

    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time];
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:myDate];
    return timeStr;

}

/// 检查版本更新
/// @param successBlock 成功快
/// @param failBlock 失败快
+ (void)checkVersionWithSuccess:(SuccessRequestBlock)successBlock                withFail:(FailRequestBlock)failBlock {
    STHttpRequestManager *manager = [STHttpRequestManager shareManager];
    [manager requestDataWithUrl:[NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort7001,GETVERSION] withType:RequestGet withSuccess:^(NSDictionary * _Nonnull dict) {
        
        successBlock(dict);
        
    } withFail:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        failBlock(task,error);
        
    }];
}

@end
