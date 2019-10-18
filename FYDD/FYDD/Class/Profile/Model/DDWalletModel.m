//
//  DDWalletModel.m
//  FYDD
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDWalletModel.h"

@implementation DDWalletModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"walletId":@"id"};
}
@end
