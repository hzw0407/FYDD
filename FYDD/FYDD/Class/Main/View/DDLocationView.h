//
//  DDLocationView.h
//  FYDD
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDLocationView : UIView
@property (weak, nonatomic) IBOutlet UIButton *nameLb;
@property (nonatomic,copy) DDcommitButtonBlock event;
@end


