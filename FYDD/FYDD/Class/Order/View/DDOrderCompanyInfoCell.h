//
//  DDOrderCompanyInfoCell.h
//  FYDD
//
//  Created by mac on 2019/4/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDOrderCompanyInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;

@property (weak, nonatomic) IBOutlet UILabel *companyLb;
@property (weak, nonatomic) IBOutlet UILabel *cityLv;
@property (weak, nonatomic) IBOutlet UILabel *xsfLb;

@property (nonatomic,copy) DDcommitButtonValueBlock  event;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTop;
@end


