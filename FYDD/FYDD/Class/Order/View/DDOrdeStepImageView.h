//
//  DDOrdeStepImageView.h
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDOrdeStepImageView : UIView
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic,copy) void (^stepOrderButtonDidClick)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
