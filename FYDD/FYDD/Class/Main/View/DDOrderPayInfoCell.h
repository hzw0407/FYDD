//
//  DDOrderPayInfoCell.h
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDOrderPayInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb2;

@property (weak, nonatomic) IBOutlet UILabel *priceLb1;
@property (weak, nonatomic) IBOutlet UILabel *priceLb2;
@property (weak, nonatomic) IBOutlet UILabel *priceLb3;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (void)setProductPrice:(double)price;
- (void)setProductCost:(double)price;
- (void)setTotalPrice:(double)price;
@end

NS_ASSUME_NONNULL_END
