//
//  FYSTBannerCell.h
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBannerModel.h"


@interface FYSTBannerCell : UITableViewCell  <UIScrollViewDelegate>{
    UIView * _currentPageView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrolView;
@property (nonatomic,strong) NSArray * banners;
@property (nonatomic,copy) void (^bannerDidClick)(NSInteger index);
@end


