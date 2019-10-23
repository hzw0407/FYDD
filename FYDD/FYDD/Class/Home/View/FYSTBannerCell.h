//
//  FYSTBannerCell.h
//  FYDD
//
//  Created by wenyang on 2019/8/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBannerModel.h"

@protocol FYSTBannerCellDelegate <NSObject>

//点击某个功能
- (void)clickFunction:(NSInteger)index;
//点击某个消息
- (void)clickMessage:(NSInteger)index;

@end

@interface FYSTBannerCell : UITableViewCell  <UIScrollViewDelegate>
//{
//    UIView * _currentPageView;
//}
//@property (weak, nonatomic) IBOutlet UIScrollView *contentScrolView;
//@property (nonatomic,strong) NSArray * banners;
@property (nonatomic,copy) void (^bannerDidClick)(NSInteger index);
@property (nonatomic, weak) id<FYSTBannerCellDelegate>delegate;

//刷新广告数据
- (void)refreshWithArray:(NSArray *)banners;
//刷新板块数据
- (void)refreshPlateWithArray:(NSArray *)plateArray;
//刷新消息数据
- (void)refreshMessageWithArray:(NSArray *)messAgeArray;

@end


