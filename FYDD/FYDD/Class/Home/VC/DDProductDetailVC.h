//
//  DDProductDetailVC.h
//  FYDD
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProductItem.h"
#import "DDProductObj.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDProductDetailVC : DDBaseVC
@property (nonatomic,assign) DDProductObj * item;
@end

NS_ASSUME_NONNULL_END
