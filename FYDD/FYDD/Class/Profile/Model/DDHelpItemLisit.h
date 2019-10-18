//
//  DDHelpItemLisit.h
//  FYDD
//
//  Created by mac on 2019/4/15.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DDHelpItemLisit : NSObject
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *createDate;
@property (assign, nonatomic) BOOL delFlag;
@property (assign, nonatomic) NSInteger heplId;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger userId;
@end


