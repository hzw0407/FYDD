//
//  DDCommitCell.h
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDCommitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (copy, nonatomic) DDcommitButtonBlock event;
@end


