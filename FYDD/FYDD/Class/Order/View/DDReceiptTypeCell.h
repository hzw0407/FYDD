//
//  DDReceiptTypeCell.h
//  FYDD
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDReceiptTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (nonatomic,strong)DDcommitButtonValueBlock event;
@end

