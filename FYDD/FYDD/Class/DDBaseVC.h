//
//  DDBaseVC.h
//  FYDD
//
//  Created by mac on 2019/4/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDBaseVC : UIViewController
- (void)checkLoginStatus:(void (^)(BOOL isLogged))block;
- (void)checkUserInfo:(void (^)(BOOL finish))block;
- (void)login:(BOOL)animated;
@end


