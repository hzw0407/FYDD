//
//  DDTabBarC.m
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDTabBarC.h"
#import "FYSTHomeVc.h"
#import "BWPlanVc.h"
#import "DDOpportunityVc.h"
#import "DDTraceVc.h"
#import "DDAidVc.h"
#import "DDInteractVc.h"
@interface DDTabBarC ()

@end

@implementation DDTabBarC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FYSTHomeVc * vc1 = [FYSTHomeVc new];
    UINavigationController * nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    vc1.title = @"首页";
    vc1.tabBarItem.image = [UIImage imageNamed:@"icon_tabBar1"];
    [self addChildViewController:nav1];
    
    BWPlanVc * vc2 = [BWPlanVc new];
    UINavigationController * nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    vc2.title = @"百万计划";
    vc2.tabBarItem.image = [UIImage imageNamed:@"icon_tabBar2"];
    [self addChildViewController:nav2];
    
    DDOpportunityVc * vc3 = [DDOpportunityVc new];
    UINavigationController * nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    vc3.title = @"商机";
    vc3.tabBarItem.image = [UIImage imageNamed:@"icon_tabBar3"];
    [self addChildViewController:nav3];
    
    DDTraceVc * vc4 = [DDTraceVc new];
    UINavigationController * nav4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    vc4.title = @"足迹";
    vc4.tabBarItem.image = [UIImage imageNamed:@"icon_tabBar4"];
    [self addChildViewController:nav4];
    
    
    DDInteractVc * vc5 = [DDInteractVc new];
    UINavigationController * nav5 = [[UINavigationController alloc] initWithRootViewController:vc5];
    vc5.title = @"互助";
    vc5.tabBarItem.image = [UIImage imageNamed:@"icon_tabBar5"];
    [self addChildViewController:nav5];
}


@end
