//
//  DDOrderUserCell.h
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOnlineModel.h"


@interface DDOrderUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *userLb;
@property (weak, nonatomic) IBOutlet UITextField *contactTd;
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneTd;
@property (weak, nonatomic) IBOutlet UILabel *cityLb;

@property (nonatomic,copy) DDInputTextKeyBlock textChange;
@property (nonatomic,copy) DDcommitButtonValueBlock event;
@property (nonatomic,copy) DDInputTextBlock textBlock;

@property (weak, nonatomic) IBOutlet UILabel *nameLb1;
@property (weak, nonatomic) IBOutlet UILabel *nameLb2;
@property (weak, nonatomic) IBOutlet UILabel *nameLb3;
@property (weak, nonatomic) IBOutlet UIImageView *circleView;

@property (nonatomic,strong) DDOnlineModel * onlineUser;
@end


