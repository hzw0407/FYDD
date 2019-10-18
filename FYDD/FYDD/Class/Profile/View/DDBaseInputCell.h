//
//  DDBaseInputCell.h
//  FYDD
//
//  Created by mac on 2019/4/25.
//  Copyright © 2019 www.sante.com. All rights reserved.

#import <UIKit/UIKit.h>



@interface DDBaseInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UITextField *contentLb;
@property (weak, nonatomic) IBOutlet UIImageView *dictView;
@property (nonatomic,copy) DDInputCellTextChange  textChange;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (weak, nonatomic) IBOutlet UILabel *textLb;
@end


