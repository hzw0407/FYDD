//
//  DDMainMenuCellView.h
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDMainMenuCellView : UIView
@property (nonatomic,copy) DDcommitButtonValueBlock event;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

NS_ASSUME_NONNULL_END
