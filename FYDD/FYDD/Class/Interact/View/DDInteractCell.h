//
//  DDInteractCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDInteractObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDInteractCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *commentLb;
@property (nonatomic,strong) DDInteractObj * interactObj;
@end

NS_ASSUME_NONNULL_END
