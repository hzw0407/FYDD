//
//  DDOrderCarryCell.h
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDGradeModel.h"


@interface DDOrderCarryCell : UITableViewCell {
    
    UIButton * _nextButton;
}
@property (weak, nonatomic) IBOutlet UIButton *currentBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *moneyLb1;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLb;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (copy,nonatomic) DDcommitButtonValueBlock event;

@property (nonatomic,strong) NSArray <DDGradeModel *>*items;

@property (nonatomic,assign) double price;
@end


