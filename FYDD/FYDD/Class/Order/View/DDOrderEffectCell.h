//
//  DDOrderEffectCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"
#import "DDOrderDetailObj.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDOrderEffectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contactNameLb;
@property (weak, nonatomic) IBOutlet UIButton *contactPhoneLb;
@property (weak, nonatomic) IBOutlet UILabel *contactTimeLb;
@property (weak, nonatomic) IBOutlet LCStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLb;
@property (nonatomic,strong) DDOrderDetailObj * detailObj;
@end

NS_ASSUME_NONNULL_END
