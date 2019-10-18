//
//  DDGetMoneyPasswordView.h
//  FYDD
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDGetMoneyPasswordView : UIView
@property (nonatomic,assign) double money;
@property (weak, nonatomic) IBOutlet UILabel *costLb;
@property (nonatomic,copy) NSString* title;
- (void)showFrom:(UIViewController *)from completion:(DDInputTextBlock)completion;
@end

NS_ASSUME_NONNULL_END
