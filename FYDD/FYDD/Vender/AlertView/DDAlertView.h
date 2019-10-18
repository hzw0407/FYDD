//
//  DDAlertView.h
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DDAlertView : UIView

+ (void)showTitle:(NSString *)title
         subTitle:(NSString *)subTitle
      cancelEvent:(DDcommitButtonBlock)event;

+ (void)showTitle:(NSString *)title
         subTitle:(NSString *)subTitle
        sureEvent:(DDcommitButtonBlock)event
      cancelEvent:(DDcommitButtonBlock)event;

+ (void)showTitle:(NSString *)title
         subTitle:(NSString *)subTitle
      actionName1:(NSString *)name1
      actionName2:(NSString *)name2
        sureEvent:(DDcommitButtonBlock)event
      cancelEvent:(DDcommitButtonBlock)event1;

+ (void)showTitle:(NSString *)title
         subTitle:(NSString *)subTitle
        sureEvent:(DDcommitButtonBlock)event
      cancelEvent:(DDcommitButtonBlock)event1
       autoSize:(BOOL)isAuto;
@end

