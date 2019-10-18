//
//  FYSDFootprintModel.h
//  FYDD
//
//  Created by wenyang on 2019/8/28.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FYSDFootprintModel : NSObject
@property (nonatomic,copy) NSString * showImage;
@property (nonatomic,copy) NSString * contents;
@property (nonatomic,assign) NSInteger commentNumber;
@property (nonatomic,copy) NSString * createUserName;
@property (nonatomic,copy) NSString * updateTime;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,assign) NSInteger footprintId;
@end

