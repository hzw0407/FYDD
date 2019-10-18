//
//  DDInteractAddView.h
//  FYDD
//
//  Created by wenyang on 2019/9/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDInteractAddView : UIView
@property (nonatomic,copy) void (^interactBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
