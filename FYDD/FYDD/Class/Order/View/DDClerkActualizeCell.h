//
//  DDClerkActualizeCell].h
//  FYDD
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"
#import "DDOrderDetailInfo.h"

@interface DDClerkActualizeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet LCStarRatingView *rateVierw;
@property (weak, nonatomic) IBOutlet UILabel *percentLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;

@property (strong , nonatomic) DDOrderDetailInfo * info;
@end


