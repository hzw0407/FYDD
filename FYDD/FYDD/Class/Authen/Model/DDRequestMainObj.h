//
//  DDRequestMainObj.h
//  FYDD
//
//  Created by wenyang on 2019/9/3.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DDRequestMainObj : NSObject
@property (nonatomic,copy) NSString * questionId;
// 题目类型 (1单选，2，多选，3，判断)
@property (nonatomic,assign) NSInteger type;
// 题目
@property (nonatomic,copy) NSString * title;
// 总提数
@property (nonatomic,assign) NSInteger sumNo;
@property (nonatomic,assign) NSInteger currentNo;
// 选择
@property (nonatomic,copy) NSString * aSelect;
@property (nonatomic,copy) NSString * bSelect;
@property (nonatomic,copy) NSString * cSelect;
@property (nonatomic,copy) NSString * dSelect;

@property (nonatomic,assign) NSInteger isASelect;
@property (nonatomic,assign) NSInteger isBSelect;
@property (nonatomic,assign) NSInteger isCSelect;
@property (nonatomic,assign) NSInteger isDSelect;
// 答案
@property (nonatomic,copy) NSString * result;
@property (nonatomic,assign) NSInteger nextNum;
@property (nonatomic,assign) NSInteger preNum;
// 考试时间
@property (nonatomic,assign) NSInteger examTime;
@property (nonatomic,copy) NSString * userAnswer;

// 计算高度
@property (nonatomic,assign) double titleHeight;
@property (nonatomic,assign) double aSelectHeight;
@property (nonatomic,assign) double bSelectHeight;
@property (nonatomic,assign) double cSelectHeight;
@property (nonatomic,assign) double dSelectHeight;
- (void)layoutHeight;
@end


