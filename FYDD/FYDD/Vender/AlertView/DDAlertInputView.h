//
//  DDAlertInputView.h
//  FYDD
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDAlertInputView : UIView
+ (void)showEvent:(DDInputTextBlock)event
      cancelEvent:(DDcommitButtonBlock)cancel;
@end

NS_ASSUME_NONNULL_END
