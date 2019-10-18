//
//  DDEncodeObject.m
//  FYDD
//
//  Created by mac on 2019/3/26.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDEncodeObject.h"
#import <objc/runtime.h>


@implementation DDEncodeObject

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        unsigned int count = 0;
        
        Ivar *ivarList = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivarList[i];
            const char *ivarName = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:ivarName];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivarList); //释放指针
    }
    return self;
}

//归档操作
- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count = 0;
    
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (NSInteger i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivarList); //释放指针
}

@end
