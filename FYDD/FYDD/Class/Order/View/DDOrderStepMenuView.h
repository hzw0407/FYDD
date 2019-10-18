//
//  DDOrderStepMenuView.h
//  FYDD
//
//  Created by wenyang on 2019/9/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDOrderStepMenuView : UIView
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

+ (void)show:(void (^)(BOOL isAgree))action;
@end

NS_ASSUME_NONNULL_END
