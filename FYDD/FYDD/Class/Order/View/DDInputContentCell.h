//
//  DDInputCell.h
//  FYDD
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDInputContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UITextField *contentLb;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,copy) DDInputCellTextChange  textChange;
@end


