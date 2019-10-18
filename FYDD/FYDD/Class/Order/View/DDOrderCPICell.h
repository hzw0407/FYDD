//
//  DDOrderCPICell.h
//  FYDD
//
//  Created by mac on 2019/4/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOrderDetailInfo.h"


@interface DDOrderCPICell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLb;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb1;
@property (weak, nonatomic) IBOutlet UILabel *dayLb;



@property (weak, nonatomic) IBOutlet UILabel *moneyLb1;
@property (weak, nonatomic) IBOutlet UILabel *moneLb2;
@property (weak, nonatomic) IBOutlet UILabel *moneLb3;

@property (nonatomic,strong)  DDOrderDetailInfo * info;
@end

