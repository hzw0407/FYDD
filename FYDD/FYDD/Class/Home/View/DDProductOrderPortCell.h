//
//  DDProductOrderPortCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/7.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProductObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDProductOrderPortCell : UITableViewCell <UIPickerViewDelegate,UIPickerViewDataSource> {
    NSInteger _currentRow;
}
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *softPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *onlinePriceLb;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLb;
@property (nonatomic,strong) DDProductDetailObj * detailObj;
@end

NS_ASSUME_NONNULL_END
