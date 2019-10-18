//
//  DDCityModel.h
//  FYDD
//
//  Created by mac on 2019/4/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DDCityModel : NSObject
@property (nonatomic,copy) NSString * biginTime;
@property (nonatomic,assign) NSInteger cityCode;
@property (nonatomic,copy) NSString * cityName;
@end

@interface DDAreaModel : NSObject
@property (nonatomic,copy) NSString * areaName;
@property (nonatomic,copy) NSString *  createTime;
@property (nonatomic,copy) NSString * provinceName;
@property (nonatomic,copy) NSString * provinces;
@property (nonatomic,copy) NSString * status;
@end


