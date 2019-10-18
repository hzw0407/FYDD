//
//  DDSequentialTypeChooseVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/10.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDSequentialTypeChooseVc.h"
#import "DDSequentialExercisesVc.h"
@interface DDSequentialTypeChooseVc ()
@property (weak, nonatomic) IBOutlet UILabel *textLb;
@property (weak, nonatomic) IBOutlet UIButton *contiueButton;
@property (weak, nonatomic) IBOutlet UIButton *contouButton;

@end

@implementation DDSequentialTypeChooseVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"顺序练习";
    _contiueButton.layer.cornerRadius = 20;
    _contiueButton.layer.masksToBounds = YES;
    
    _contouButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _contouButton.layer.shadowOffset = CGSizeMake(0,3);
    _contouButton.layer.shadowRadius = 6;
    _contouButton.layer.shadowOpacity = 1;
    _contouButton.layer.cornerRadius = 20;
}

- (IBAction)countinueButtonDidClick:(UIButton *)sender {
    DDSequentialExercisesVc * vc = [DDSequentialExercisesVc new];
    vc.isContinue = sender.tag == 0;
    vc.userType = _userType;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
