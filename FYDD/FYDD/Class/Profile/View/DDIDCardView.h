//
//  DDIDCardView.h
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDIDCardViewDelegate <NSObject>

//点击功能
- (void)clickIndex:(NSInteger)index;

@end

@interface DDIDCardView : UIView

@property (nonatomic, weak) id<DDIDCardViewDelegate>delegate;

//刷新数据
- (void)refrehsInfoWithDic:(NSDictionary *)dic;

@end

