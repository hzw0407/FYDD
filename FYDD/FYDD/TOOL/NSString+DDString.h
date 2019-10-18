//
//  NSString+DDString.h
//  FYDD
//
//  Created by mac on 2019/4/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSString (DDString)
- (BOOL)isInvalidEmail;

// 对时间进行处理
- (NSString *)formateServiceDate;
@end

