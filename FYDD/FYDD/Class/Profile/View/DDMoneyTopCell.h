//
//  DDMoneyTopCell.h
//  FYDD
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDMoneyTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (copy,nonatomic) DDcommitButtonValueBlock event;
@property (weak, nonatomic) IBOutlet UILabel *totalLb;
@end

NS_ASSUME_NONNULL_END
