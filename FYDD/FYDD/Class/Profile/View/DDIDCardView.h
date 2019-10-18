//
//  DDIDCardView.h
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DDIDCardView : UIView
@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLb;
@property (copy , nonatomic) DDcommitButtonValueBlock  event;


@property (weak, nonatomic) IBOutlet UIButton *iconView1;
@property (weak, nonatomic) IBOutlet UIButton *iconView2;
@property (weak, nonatomic) IBOutlet UILabel *iconLb1;
@property (weak, nonatomic) IBOutlet UILabel *iconLb2;

- (void)setIconImage1:(NSString  *)url;
- (void)setIconImage2:(NSString *)url;
@end

