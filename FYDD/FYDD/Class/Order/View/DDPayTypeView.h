//
//  DDPayTypeView.h
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAlertController.h"
#import "UIView+TYAlertView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDPayTypeView : UIView
@property (nonatomic,copy) void(^event)(DDAppPayType type) ;

// 设置需要的支付方式
@property (nonatomic,assign) DDAppPayType payType;
@end

NS_ASSUME_NONNULL_END
