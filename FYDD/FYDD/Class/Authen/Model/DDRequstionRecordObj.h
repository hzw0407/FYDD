//
//  DDRequstionRecordObj.h
//  FYDD
//
//  Created by wenyang on 2019/9/10.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN         
@interface DDRequstionRecordObj : NSObject
@property (nonatomic,copy) NSString * recordId;
@property (nonatomic,copy) NSString * questionId;
@property (nonatomic,copy) NSString * result;
@property (nonatomic,copy) NSString * sceneType;
@property (nonatomic,copy) NSString * trueAnswer;
@property (nonatomic,copy) NSString * userAnswer;
@end

NS_ASSUME_NONNULL_END
