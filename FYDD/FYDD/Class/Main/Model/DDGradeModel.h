//
//  DDGradeModel.h
//  FYDD
//
//  Created by mac on 2019/4/1.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DDGradeModel : NSObject
@property (nonatomic,copy) NSString* logo;
@property (nonatomic,copy) NSString* gradeName;
@property (nonatomic,assign) NSInteger gradeCondition;
@property (nonatomic,assign) double commissionFee;
@property (nonatomic,copy) NSString* gradeDescription;

@property (nonatomic,assign) NSInteger enable;
@property (nonatomic,assign) NSInteger sort;
@property (nonatomic,assign) NSInteger gradeId;

@property (nonatomic,assign) BOOL isSelected;
@end



