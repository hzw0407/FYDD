//
//  DDBankModel.h
//  FYDD
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DDBankModel : NSObject
@property (copy, nonatomic) NSString *bankCardNumber;
@property (copy, nonatomic) NSString *bankType;
@property (copy, nonatomic) NSString *cardPhoto;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *userName;
@end


