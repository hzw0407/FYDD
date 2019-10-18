//
//  DDPaySuccessVC.h
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDPaySuccessVC : UIViewController
@property (nonatomic,assign) BOOL isWalletPay;
@property (nonatomic,copy) NSString * orderId;
@property (nonatomic,assign) BOOL isComment;
@property (nonatomic,assign) BOOL isBank;

@property (nonatomic,assign) BOOL isOrderPay;
@property (nonatomic,assign) BOOL isReceiptVCPay;
@property (nonatomic,assign) BOOL isOrderChong;
@end


