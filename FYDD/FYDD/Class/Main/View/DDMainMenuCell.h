//
//  DDMainMenuCell.h
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DDMainMenuCell : UITableViewCell
@property (nonatomic,copy) DDcommitButtonValueBlock event;
- (void)setMenuDatas:(NSArray <NSDictionary *>*)data;

@end

