//
//  DDProductObj.m
//  FYDD
//
//  Created by wenyang on 2019/9/7.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProductObj.h"

@implementation DDProductPort
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"portId":@"id"};
}

@end

@implementation DDProductObj
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"objId":@"id"};
}

@end

@implementation DDProductDetailObj
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"list" : [DDProductPort class]};
}

- (DDProductPort *)port {
    if (!_port && _list.count) {
        _port = _list[0];
    }
    return _port;
}
@end
