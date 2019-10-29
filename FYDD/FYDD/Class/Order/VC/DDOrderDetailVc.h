//
//  DDOrderDetailVc.h
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDOrderDetailVc : DDBaseVC

@property (nonatomic,copy) NSString * orderId;
//1企业用户 2代理方 3实施方
@property (nonatomic, assign) NSInteger type;

@end


