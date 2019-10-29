//
//  DDOrderDetailObj.m
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderDetailObj.h"

@implementation DDOrderDetailObj
- (DDOrderStatus)orderStatusType {
    return convertOrderStatus(_orderStatus,_isCompanyFirst);
}
@end
