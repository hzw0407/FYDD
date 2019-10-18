//
//  NSString+DDString.m
//  FYDD
//
//  Created by mac on 2019/4/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "NSString+DDString.h"

@implementation NSString (DDString)
- (BOOL)isInvalidEmail{
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:self];
}

- (NSString *)formateServiceDate{
    if ([self rangeOfString:@"T"].location != NSNotFound) {
        NSArray * dataList = [self componentsSeparatedByString:@"T"];
        if (dataList.count > 0) {
            return dataList[0];
        }
    }
    if (!self || [self isEqualToString:@""]||[self isEqualToString:@"nil"] || [self isEqualToString:@"(null)"]){
        return @"";
    }
    return self;
}
@end
