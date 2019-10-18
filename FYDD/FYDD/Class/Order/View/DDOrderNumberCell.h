//
//  DDOrderNumberCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOrderDetailObj.h"


@interface DDOrderNumberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dispDateNameLb;
@property (weak, nonatomic) IBOutlet UILabel *orderLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *paidanLv;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *feiyongLb;
@property (weak, nonatomic) IBOutlet UILabel *shiyongLb;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *remainDateLb;

@property (nonatomic,strong) DDOrderDetailObj * detailObj;
@property (weak, nonatomic) IBOutlet UILabel *nameLb2;
@property (weak, nonatomic) IBOutlet UILabel *nameLb3;
@property (weak, nonatomic) IBOutlet UILabel *nameLb4;
@property (weak, nonatomic) IBOutlet UILabel *nameLb5;
@end


