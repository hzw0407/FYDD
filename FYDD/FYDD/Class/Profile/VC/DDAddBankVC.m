//
//  DDAddBankVC.m
//  FYDD
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDAddBankVC.h"
#import "DDAlertView.h"

@interface DDAddBankVC ()
@property (weak, nonatomic) IBOutlet UIImageView *bankIconView;
@property (weak, nonatomic) IBOutlet UITextField *bankNoLb;
@property (weak, nonatomic) IBOutlet UITextField *bankNameLb;
@property (weak, nonatomic) IBOutlet UITextField *codeLb;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@end

@implementation DDAddBankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    
    self.codeBtn.layer.borderColor = UIColorHex(0x549BF3).CGColor;
    self.codeBtn.layer.borderWidth = 1;
}

- (IBAction)getCodeBtnDidClick {
    
}

// 绑定银行卡
- (IBAction)baddingBankBtnDidClick {
    [DDAlertView showTitle:@"温馨提示" subTitle:@"添加银行卡成功" cancelEvent:^{
        
    }];
}

@end
