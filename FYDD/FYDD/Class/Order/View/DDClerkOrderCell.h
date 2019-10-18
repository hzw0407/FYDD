//
//  DDClerkOrderCell.h
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOrderInfo.h"


@interface DDClerkOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNoLb;
@property (weak, nonatomic) IBOutlet UIView *orderBottomView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *lastPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *remainLb;

@property (nonatomic,strong) DDOrderInfo * info;


@end

