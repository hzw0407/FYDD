//
//  DDDownServceCell.h
//  FYDD
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDDownServceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,copy) DDcommitButtonValueBlock event;
@end


