//
//  DDProductItemView.h
//  FYDD
//
//  Created by wenyang on 2019/9/7.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDProductItemView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (nonatomic,copy) void (^itemBlock)(NSInteger type);
@end


