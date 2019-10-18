//
//  AppDelegate.h
//  FYDD
//
//  Created by mac on 2019/2/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <WXApi.h>
#import "DDMainVC.h"
#import "FYSTHomeVc.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate> {
    FYSTHomeVc * _mainVc;
    BOOL _gotoPush;
}
@property (strong, nonatomic) UIWindow *window;
@end

