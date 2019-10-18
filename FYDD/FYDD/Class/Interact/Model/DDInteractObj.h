//
//  DDInteractObj.h
//  FYDD
//
//  Created by wenyang on 2019/9/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDInteractObj : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * types;
@property (nonatomic,copy) NSString * updateTime;
@property (nonatomic,copy) NSString * showImage;
@property (nonatomic,copy) NSString * objId;
@property (nonatomic,assign) NSInteger likesNumber;
@property (nonatomic,assign) NSInteger commentNumber;
@property (nonatomic,copy) NSString * createUserLogo;
@property (nonatomic,copy) NSString * createUserName;
@property (nonatomic,copy) NSString * createTime;
@property (nonatomic,copy) NSString * contents;

@property (nonatomic,assign) double titleHeight;
@property (nonatomic,assign) double contentHeight;
@property (nonatomic,assign) double cellHeight;
@property (nonatomic,assign) CGSize imageSize;
- (void)layout;

@end

NS_ASSUME_NONNULL_END
