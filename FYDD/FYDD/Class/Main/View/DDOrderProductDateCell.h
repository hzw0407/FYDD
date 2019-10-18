//
//  DDOrderProductDateCell.h
//  FYDD
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProductItem.h"

@interface DDOrderProductDateCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (nonatomic,strong) NSArray <DDProductPriceItem *>*items;

@property (nonatomic,copy) void (^event)(DDProductPriceItem * item);
@end


