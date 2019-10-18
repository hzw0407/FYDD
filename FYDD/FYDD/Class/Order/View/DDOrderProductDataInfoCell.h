//
//  DDOrderProductInfoCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"
#import "DDOrderDetailObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDOrderProductDataInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productNamelB;
@property (weak, nonatomic) IBOutlet UILabel *productCountLb;
@property (weak, nonatomic) IBOutlet UILabel *shouliLb;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet LCStarRatingView *startRatingView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLb;
@property (nonatomic,strong) DDOrderDetailObj * detailObj;
@end

NS_ASSUME_NONNULL_END
