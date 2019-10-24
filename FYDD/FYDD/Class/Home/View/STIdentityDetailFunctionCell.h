//
//  STIdentityDetailFunctionCell.h
//  FYDD
//
//  Created by 何志武 on 2019/10/22.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol STIdentityDetailFunctionCellDelegate <NSObject>

//点击某个功能
- (void)clickIndex:(NSInteger)index;
//点击申请
- (void)applyClick;

@end

@interface STIdentityDetailFunctionCell : UITableViewCell

@property (nonatomic, weak) id<STIdentityDetailFunctionCellDelegate>delegate;
//刷新数据
- (void)refreshDataWithType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
