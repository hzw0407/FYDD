//
//  DDTradeDetailVc.h
//  FYDD
//
//  Created by wenyang on 2019/9/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFootstripObj.h"

NS_ASSUME_NONNULL_BEGIN
@interface DDTradeDetailVc : UIViewController
@property (nonatomic,assign) BOOL  isMe;
@property (nonatomic,strong) DDFootstripObj * footstripObj;
@end

NS_ASSUME_NONNULL_END
