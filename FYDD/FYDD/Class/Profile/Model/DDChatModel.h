//
//  DDChatModel.h
//  FYDD
//
//  Created by mac on 2019/4/15.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDChatModel : NSObject
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *userAvatar;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger replyType;
@property (copy, nonatomic) NSString * createDate;
@property (nonatomic,assign) CGFloat height;
// 计算cell高度
- (void)layout;
@end


