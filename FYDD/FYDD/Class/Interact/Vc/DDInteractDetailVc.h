//
//  DDInteractDetailVc.h
//  FYDD
//
//  Created by wenyang on 2019/9/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDInteractObj.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDInteractDetailVc : UIViewController
@property (nonatomic,assign) BOOL  isMe;
@property (nonatomic,strong) DDInteractObj * footstripObj;
@end

NS_ASSUME_NONNULL_END
