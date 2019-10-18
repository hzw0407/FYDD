//
//  DDBankListView.h
//  FYDD
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBankModel.h"

@interface DDBankListView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray <DDBankModel *>*bankList;


@property (nonatomic,copy) DDcommitButtonValueBlock event;

@end

