//
//  DDAuthenMoniResultVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/11.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDAuthenMoniResultVc.h"
#import "DDAuthenMoniVc.h"

@interface DDAuthenMoniResultVc ()
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UILabel *textLB;
@property (weak, nonatomic) IBOutlet UIImageView *succLogoView;
@property (weak, nonatomic) IBOutlet UIImageView *succView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *prcentLb;
@property (weak, nonatomic) IBOutlet UILabel *heScoreLb;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation DDAuthenMoniResultVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.backgroundColor = [DDAppManager share].appTintColor;
    self.title =  _isSilmimator ? @"模拟考试得分": @"考试得分";
    
    _containerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _containerView.layer.shadowOffset = CGSizeMake(0,3);
    _containerView.layer.shadowRadius = 6;
    _containerView.layer.shadowOpacity = 1;
    _containerView.layer.cornerRadius = 10;
    
    _button1.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _button1.layer.shadowOffset = CGSizeMake(0,3);
    _button1.layer.shadowRadius = 6;
    _button1.layer.shadowOpacity = 1;
    _button1.layer.cornerRadius = 20;
    
    _button2.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _button2.layer.shadowOffset = CGSizeMake(0,3);
    _button2.layer.shadowRadius = 6;
    _button2.layer.shadowOpacity = 1;
    _button2.layer.cornerRadius = 20;

    [self getData];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVc)];
    
    _circleView.layer.cornerRadius = 70;
    _circleView.layer.masksToBounds = YES;
    _circleView.layer.borderColor = UIColorHex(0xEF8200).CGColor;
    _circleView.layer.borderWidth = 1;
}

- (IBAction)dismissVc{
    [DDAppManager popVc:@"DDAuthenVc" navigtor:self.navigationController];
}


- (IBAction)aginButtonDidClick:(id)sender {
    DDAuthenMoniVc * vc = [DDAuthenMoniVc new];
    vc.isSilmimator = _isSilmimator;
    vc.userType = _userType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBar];
}

- (void)setupNavigationBar{
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [DDAppManager share].appTintColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:true];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [DDAppManager share].navigationTintColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : UIColorHex(0x193750),
                                                                      }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:true];
}

//提交考试答案
- (void)getData{
    [DDHub hub:self.view];
    @weakify(self)
    NSString * url = [NSString stringWithFormat:@"%@/exam/question/bank/model/commitPaperOfModelTests?identityType=%@&token=%@",DDAPP_2T_URL, _userType == DDUserTypePromoter ? @(2) : @(1),[DDUserManager share].user.token];
    if (!_isSilmimator) {
        url = [NSString stringWithFormat:@"%@/exam/question/bank/live/commitPaperOfLiveExam?identityType=%@&token=%@",DDAPP_2T_URL, _userType == DDUserTypePromoter ? @(2) : @(1),[DDUserManager share].user.token];
    }
    
    [[DDAppNetwork share] get:YES
                          url:url
                   parameters:nil
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           NSInteger userScore = [data[@"userScore"] integerValue];
                           NSInteger trueRate = [data[@"trueRate"] integerValue];
                           NSInteger passingScore = [data[@"passingScore"] integerValue];
                           NSInteger costTime = [data[@"costTime"] integerValue];
                           NSString * qualificatedCode = data[@"qualificatedCode"];
                           self.heScoreLb.text = [NSString stringWithFormat:@"%zd",passingScore];
                           self.prcentLb.text = [NSString stringWithFormat:@"%zd",trueRate];
                           self.scoreLb.text = [NSString stringWithFormat:@"%zd",userScore];
                           self.heScoreLb.text = [NSString stringWithFormat:@"%zd",passingScore];
                           NSInteger hourTen = costTime/3600/10;
                           NSInteger hourGe = costTime/3600%10;
                           NSInteger MinTen = costTime%3600/600;
                           NSInteger MinGe = costTime%3600/60%10;
                           NSInteger miaoTen = costTime%60/10;
                           NSInteger miaoGe = costTime%60%10;
                           self.timeLB.text = [NSString stringWithFormat:@"%zd%zd:%zd%zd:%zd%zd",hourTen,hourGe,MinTen,MinGe,miaoTen,miaoGe];
                           if (!self.isSilmimator) {
                               self.textLB.hidden = NO;
                               self.succLogoView.hidden = NO;
                               if (yyTrimNullText(qualificatedCode).length > 0) {
                                   self.textLB.text = [NSString stringWithFormat:@"恭喜进通过实施员考试\n资格编号：%@",qualificatedCode];
                                   self.succLogoView.image = [UIImage imageNamed:@"icon_suc"];
                                   self.succView.hidden = NO;
                               }else {
                                   self.textLB.text = [NSString stringWithFormat:@"很遗憾未能通过%@考试",self.userType == DDUserTypeOnline ? @"实施方" : @"代理方"];
                                   self.succLogoView.image = [UIImage imageNamed:@"icon_fail"];
                                   self.succView.hidden = YES;
                               }
                           }
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}


@end
