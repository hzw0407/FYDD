//
//  DDClerkMenuView.h
//  FYDD
//
//  Created by wenyang on 2019/8/23.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDClerkMenuView : UIView
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView1;
@property (weak, nonatomic) IBOutlet UIImageView *iconView2;
@property (nonatomic,copy) void (^clertButtonClick)(NSInteger index);
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button1;
- (void)reloadView;
@end

NS_ASSUME_NONNULL_END
