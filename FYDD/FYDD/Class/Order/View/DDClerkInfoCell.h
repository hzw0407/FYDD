//
//  DDClerkInfoCell.h
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOrderDetailInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDClerkInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *circleViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *circleLbs;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLb;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLb;
@property (weak, nonatomic) IBOutlet UILabel *textLb1;
@property (weak, nonatomic) IBOutlet UILabel *textLb2;
@property (weak, nonatomic) IBOutlet UILabel *textLb3;
@property (weak, nonatomic) IBOutlet UILabel *textLb4;
@property (weak, nonatomic) IBOutlet UILabel *textLb5;

@property (weak, nonatomic) IBOutlet UIView *widthView;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,strong) DDOrderDetailInfo * info;
@end

NS_ASSUME_NONNULL_END
