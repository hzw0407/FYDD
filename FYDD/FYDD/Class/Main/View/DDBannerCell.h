//
//  DDBannerCell.h
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBannerTopModel.h"


@interface DDBannerCell : UITableViewCell
@property (nonatomic,strong) NSArray <DDBannerTopModel *>*banners;
@property (nonatomic,copy) DDcommitButtonValueBlock event;
@end


