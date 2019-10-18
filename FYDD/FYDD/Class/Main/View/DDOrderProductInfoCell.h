//
//  DDOrderProductInfoCell.h
//  FYDD
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDOrderProductInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;


@property (nonatomic,assign) double price;
@property (nonatomic,copy) DDcommitButtonBlock event;
@end


