//
//  DDProductOrderOnlineCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/7.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProductObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDProductOrderOnlineCell : UITableViewCell  <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic,copy) void (^onlineBlock)(NSInteger type);
@property (nonatomic,copy) void (^onlineSeachBarBlock)(NSString * searchText);
@property (nonatomic,strong) DDProductDetailObj *obj;
@end

NS_ASSUME_NONNULL_END
