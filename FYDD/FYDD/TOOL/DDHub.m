//
//  DDHub.m
//  FYDD
//
//  Created by mac on 2019/3/25.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDHub.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
@implementation DDHub

+ (void)hubText:(NSString *)text{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self hub:text view:delegate.window];
}

+ (void)hub:(UIView *)view{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void)hub:(NSString *)text view:(UIView *)view {
    [self hub:text view:view delay:0.5];
}

+ (void)hub:(NSString *)text view:(UIView *)view delay:(CGFloat)delay{
    [MBProgressHUD hideHUDForView:view animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(delay * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
                       hud.label.text = text;
                       hud.label.textColor = [UIColor  blackColor];
                       hud.label.font = [UIFont systemFontOfSize:17.0];
                       hud.userInteractionEnabled= NO;
                       hud.label.numberOfLines = 0;
                       hud.bezelView.backgroundColor =UIColor.grayColor;    //背景颜色
                       hud.mode = MBProgressHUDModeText;
                       hud.removeFromSuperViewOnHide = YES;
                       [hud hideAnimated:YES afterDelay:1.5];
                   });

}

+ (void)dismiss:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}



@end
