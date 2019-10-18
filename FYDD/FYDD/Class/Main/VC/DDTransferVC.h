//
//  DDTransferVC.h
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDTransferVC : UIViewController
@property (nonatomic,copy) NSString * money;
@property (nonatomic,copy) NSString * orderNumber;

@property (nonatomic,assign) BOOL isChongZhi;
@property (nonatomic,assign) BOOL isOrderPay;
@property (nonatomic,assign) BOOL isOrderChong;
@end

NS_ASSUME_NONNULL_END
