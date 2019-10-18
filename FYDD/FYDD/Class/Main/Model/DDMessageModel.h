//
//  DDMessageModel.h
//  FYDD
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DDMessageModel : NSObject
@property (nonatomic,copy) NSString * messageContent;
@property (nonatomic,copy) NSString * messageName;
@property (nonatomic,copy) NSString * requestUrl;
@property (nonatomic,copy) NSString * messageBrief;
@property (nonatomic,copy) NSString * createTime;
@property (nonatomic,copy) NSString * messageId;
@property (nonatomic,assign)NSInteger state;
@property (nonatomic,assign)NSInteger userIdType;
- (void)layout;
@end


