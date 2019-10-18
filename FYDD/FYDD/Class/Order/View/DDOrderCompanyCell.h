//
//  DDOrderCompanyCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDOrderDetailObj.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDOrderCompanyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contactNameLb;
@property (weak, nonatomic) IBOutlet UIButton *contactPhoneButton;
@property (weak, nonatomic) IBOutlet UILabel *contactAddtessLb;
@property (nonatomic,strong) DDOrderDetailObj * detailObj;
@end

NS_ASSUME_NONNULL_END
