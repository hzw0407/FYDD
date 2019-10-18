//
//  DDProductAgreeServiceVc.h
//  FYDD
//
//  Created by wenyang on 2019/9/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDProductAgreeServiceVc : UIViewController
@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * serviceName;
@property (nonatomic,copy) void (^argeeServiceBlock)(BOOL agree);
@end

NS_ASSUME_NONNULL_END
