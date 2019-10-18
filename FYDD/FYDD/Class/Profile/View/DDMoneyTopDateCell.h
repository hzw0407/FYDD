//
//  DDMoneyTopDateCell.h
//  FYDD
//
//  Created by mac on 2019/5/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDMoneyTopDateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (copy,nonatomic) DDcommitButtonValueBlock event;
@end


