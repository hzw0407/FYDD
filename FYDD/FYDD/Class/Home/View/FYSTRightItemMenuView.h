//
//  FYSTRightItemMenuView.h
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYSTRightItemMenuView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@property (nonatomic,copy) void (^fystMenuButtonDidClick)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
