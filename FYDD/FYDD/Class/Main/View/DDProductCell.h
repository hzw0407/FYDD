//
//  DDProductCell.h
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProductItem.h"



@interface DDProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIImageView *iconHot;
@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@property (copy , nonatomic) DDcommitButtonValueBlock event;
@property (strong,nonatomic) NSIndexPath * indexPath;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (nonatomic, strong) DDProductItem * item;
@end


