//
//  DDRequestionBarView.h
//  FYDD
//
//  Created by wenyang on 2019/9/3.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDRequestionBarView : UIView
@property (weak, nonatomic) IBOutlet UIButton *countBtn;
@property (nonatomic,copy) void (^bottomBarDidClick)(NSInteger type);
@end

NS_ASSUME_NONNULL_END
