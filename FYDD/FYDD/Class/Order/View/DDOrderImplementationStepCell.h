//
//  DDOrderImplementationStepCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOrderPlanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDOrderImplementationStepCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stepLb;
@property (weak, nonatomic) IBOutlet UILabel *stepNameLb;
@property (weak, nonatomic) IBOutlet UIButton *statusLb;

@property (weak, nonatomic) IBOutlet UIView *imageContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentHeight;

@property (weak, nonatomic) IBOutlet UILabel *ideaLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ideaConsLb;


@property (weak, nonatomic) IBOutlet UILabel *eveNameLb1;
@property (weak, nonatomic) IBOutlet UILabel *eveNameLb2;
@property (weak, nonatomic) IBOutlet UILabel *eveaNameLb3;
@property (weak, nonatomic) IBOutlet UILabel *eveStatusLb1;
@property (weak, nonatomic) IBOutlet UILabel *eveStatusLb2;
@property (weak, nonatomic) IBOutlet UILabel *eveStausLb3;

@property (weak, nonatomic) IBOutlet UILabel *commentIdeaLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentIdeaCons;


@property (nonatomic,strong) DDOrderPlanModel * planModel;
@property (nonatomic,copy) void (^comfirmBlock)(void);
@property (nonatomic,copy) void (^coverImageDidClick)(NSString * url,UIButton * fromView);
@end

NS_ASSUME_NONNULL_END
