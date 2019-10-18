//
//  DDFootstripObj.h
//  FYDD
//
//  Created by wenyang on 2019/9/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDFootstripObj : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * contents;
@property (nonatomic,copy) NSString * showImage;
@property (nonatomic,copy) NSString * updateTime;
@property (nonatomic,assign) NSInteger likesNumber;
@property (nonatomic,assign) NSInteger commentNumber;
@property (nonatomic,copy) NSString * createUserName;
@property (nonatomic,copy) NSString * createUserLogo;
@property (nonatomic,assign) NSInteger objId;
@property (nonatomic,assign) BOOL liked;

@property (nonatomic,assign) double titleHeight;
@property (nonatomic,assign) double contentHeight;
@property (nonatomic,assign) double cellHeight;
@property (nonatomic,assign) CGSize imageSize;
- (void)layout;
@end

@interface DDFootstripComment : NSObject
@property (nonatomic,copy) NSString * createTime;
@property (nonatomic,copy) NSString * createUserName;
@property (nonatomic,copy) NSString * commnet;
@property (nonatomic,copy) NSString * createUserLogo;
@property (nonatomic,copy) NSString * commentId;
@property (nonatomic,strong) NSArray  * comments;
@property (nonatomic,assign) double titleHeight;
@property (nonatomic,assign) double laxHeight;
- (void)layout;
@end

NS_ASSUME_NONNULL_END
