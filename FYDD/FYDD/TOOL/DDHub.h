//
//  DDHub.h
//  FYDD
//
//  Created by mac on 2019/3/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDHub : NSObject
+ (void)hub:(UIView *)view;
+ (void)hubText:(NSString *)text;
+ (void)hub:(NSString *)text view:(UIView *)view ;
+ (void)hub:(NSString *)text view:(UIView *)view delay:(CGFloat)delay;
+ (void)dismiss:(UIView *)view;
@end


