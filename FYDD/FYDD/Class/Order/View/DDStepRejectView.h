//
//  DDStepRejectView.h
//  FYDD
//
//  Created by wenyang on 2019/9/9.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDStepRejectView : UIView {
    NSInteger _currentIndex;
}
@property (weak, nonatomic) IBOutlet UITextField *textTd;
@property (weak, nonatomic) IBOutlet UIButton *firtButton;
@property (weak, nonatomic) UIButton *tempButton;

@property (nonatomic,copy) void (^rejectButtonDidClick)(NSString *mess);
+ (void)show:(void (^)(NSString * message))rejectCompeltion vc:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
