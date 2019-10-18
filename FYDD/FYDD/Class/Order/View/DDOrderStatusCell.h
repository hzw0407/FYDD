//
//  DDOrderStatusCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOrderDetailObj.h"
#import "DDOrderPlanModel.h"

@interface DDOrderStatusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stepNameLB;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *cirleViews;

@property (weak, nonatomic) IBOutlet UIButton *stepButton;

@property (weak, nonatomic) IBOutlet UILabel *numberLb;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *statusLbs;
@property (weak, nonatomic) IBOutlet UIView *statusLineView;
@property (weak, nonatomic) IBOutlet UIButton *statusDictButton;
@property (nonatomic,strong) DDOrderDetailObj * detailObj;

@property (weak, nonatomic) IBOutlet UIImageView *downUpView;
@property (nonatomic,strong)  DDOrderPlanModel * planModel;
@property (nonatomic,copy) void (^explandBlock)(void);
@property (nonatomic,copy) void (^comfirmBlock)(void);
@end


