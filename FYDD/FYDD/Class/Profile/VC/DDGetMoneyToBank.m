//
//  DDGetMoneyToBank.m
//  FYDD
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDGetMoneyToBank.h"
#import "DDGetMoneyPasswordView.h"
#import "UIView+TYAlertView.h"
#import "DDMoneyHistoryVC.h"
#import "DDAddBankVC.h"
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>
#import <UIButton+WebCache.h>
#import "DDPaySuccessVC.h"
#import "DDBankModel.h"
#import "DDBankListView.h"
#import "DDPayPasswordVC.h"
#import "DDAlertView.h"
@interface DDGetMoneyToBank (){
    NSString * _commission;
    double _getMoney;
    BOOL _isNoBank;
    NSString * _bankURL;
    NSString * _bankNo;
    NSString * _name;
    NSString * _bankType;
    NSArray <DDBankModel *>* _bankList;
    NSString * _limitMoney;
}

@property (weak, nonatomic) IBOutlet UITextField *monetTd;
@property (nonatomic,strong) DDGetMoneyPasswordView * passwordView;
@property (weak, nonatomic) IBOutlet UILabel *banlanceLb;
@property (weak, nonatomic) IBOutlet UIButton *camaraBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankNoBtn;

@property (weak, nonatomic) IBOutlet UIImageView *bankNoDownupView;
@property (weak, nonatomic) IBOutlet UITextField *cardNameTd;
@property (weak, nonatomic) IBOutlet UITextField *bankNoTd;
@property (weak, nonatomic) IBOutlet UITextField *bankName;
@property (weak, nonatomic) IBOutlet UIView *bankPictureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCons;
@property (nonatomic,strong ) TYAlertController * alertController;
@property(nonatomic,strong) DDBankListView * bankListView;
@property (weak, nonatomic) IBOutlet UILabel *markTextLb;
@end

@implementation DDGetMoneyToBank

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    
    _camaraBtn.layer.borderWidth = 1;
    _camaraBtn.layer.borderColor = UIColorHex(0xf5f5f5).CGColor;
    _camaraBtn.layer.cornerRadius = 4;
    _camaraBtn.clipsToBounds = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(getMoneyHistory)];
     [self showDesc:YES];
    [self getCommissionRequest];
    [_monetTd addTarget:self action:@selector(textTdDidChange) forControlEvents:UIControlEventEditingChanged];
    [self getLimitMoney];
}

- (void)textTdDidChange{
     _getMoney = [_monetTd.text doubleValue];
    [self showDesc:_monetTd.text.length == 0];
}

// 提现手续费
- (void)getCommissionRequest{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:@"/fps/wallet/getCashRate"
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSString * data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           self->_commission = data;
                           [self getBannkList];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}


- (void)getLimitMoney{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:@"/fps/wallet/getCashMessage"
                         body:@""
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       [DDHub dismiss:self.view];
                       if (code == 200) {
                           self->_limitMoney = data[@"singleCashAmount"];
                           self->_monetTd.placeholder = [NSString stringWithFormat:@"请输入提现金额(单笔最高%@)",yyTrimNullText(self->_limitMoney)];
                           self.markTextLb.text = data[@"cashRemark"];
                       }
                   }];
}

// 获取银行卡
- (void)getBannkList{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/fps/bank/card/getBankCardList?token=", [DDUserManager share].user.token)
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSArray * data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           BOOL isNoBank = false;
                           if (data && [data isKindOfClass:[NSArray class]]) {
                               if (data.count == 0) {
                                   isNoBank = true;
                               }else {
                                   NSMutableArray * dataList = @[].mutableCopy;
                                   for (NSDictionary * dic in data) {
                                       DDBankModel * bank = [DDBankModel modelWithJSON:dic];
                                       [dataList addObject:bank];
                                   }
                                   self->_bankList = dataList;
                               }
                           }else {
                               isNoBank = true;
                           }
                           self->_isNoBank = isNoBank;
                           [self updateUI];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

- (void)updateUI{

}

- (IBAction)payBtnDidClick {
    double comiis = [_commission doubleValue] * _getMoney;
    double money = [_monetTd.text doubleValue] + comiis;
    if ( money > _banlance + 0.5) {
        [DDHub hub:@"钱包余额不足" view:self.view];
        return;
    }
    
    _bankNo = _bankNoTd.text;
    _name = _cardNameTd.text;
    _bankType = _bankName.text;
    
    if (money > [yyTrimNullText(self->_limitMoney) doubleValue]) {
        [DDHub hub:[NSString stringWithFormat:@"单笔最高提现%@",yyTrimNullText(_limitMoney)] view:self.view];
        return;
    }
    
    if (money == 0) {
        [DDHub hub:@"请输入提现金额" view:self.view];
        return;
    }
    if (_name.length == 0) {
        [DDHub hub:@"请输入持卡人姓名" view:self.view];
        return;
    }
    if (_bankNo.length == 0) {
        [DDHub hub:@"请输入银行卡号" view:self.view];
        return;
    }
    if (_bankNo.length == 0) {
        [DDHub hub:@"请输入银行名称" view:self.view];
        return;
    }
    
    if (_isNoBank && _bankURL.length== 0 ){
        [DDHub hub:@"请上传银行卡正面照" view:self.view];
        return;
    }

    _passwordView = [DDGetMoneyPasswordView createViewFromNib];
    if (iPhoneXAfter) {
        _passwordView.height = 220;
    }
    _passwordView.money = [_monetTd.text doubleValue];
    _passwordView.costLb.text = [NSString stringWithFormat:@"将额外扣除¥%.2f元服务费",comiis];
    _passwordView.costLb.hidden = NO;
    @weakify(self)
    [_passwordView showFrom:self completion:^(NSString *text) {
        @strongify(self)
        // 提交
        NSString * body = [NSString stringWithFormat:@"{\"amount\" : \"%.2f\" ,\"type\" : \"1\", \"tradingAccount\" : \"%@\",\"payPassword\" : \"%@\",\"name\" : \"%@\" ,\"bankType\" : \"%@\",\"cardUrl\" : \"%@\"}",[self->_monetTd.text doubleValue],self->_bankNo,text,self->_name,self->_bankType,self->_bankURL];
        [DDHub hub:self.view];
        @weakify(self)
        [[DDAppNetwork share] get:NO
                             path:YYFormat(@"/fps/wallet/transaction/records/extractCash?token=",
                                           [DDUserManager share].user.token)
                             body:body
                       completion:^(NSInteger code,
                                    NSString *message,
                                    id data) {
                           @strongify(self)
                           if (!self) return ;
                           if (code == 200) {
                               [DDHub dismiss:self.view];
                               DDPaySuccessVC *vc = [DDPaySuccessVC new];
                               vc.isBank = YES;
                               [DDAppManager gotoVC:vc navigtor:self.navigationController];
                           }else {
                               [DDHub hub:message view:self.view];
                           }
                       }];
    }];
}



- (void)showDesc:(BOOL)isBalance{
    if (isBalance) {
        _banlanceLb.text = [NSString stringWithFormat:@"账户余额: ¥%.f",_banlance];
        _banlanceLb.textColor = UIColorHex(0xC6CFD6);
    }else {
        // 扣除多少钱
        double comiis = [_commission doubleValue] * _getMoney;
        _banlanceLb.text = [NSString stringWithFormat:@"额外扣除¥%.2f元服务费(费率%.1f%%)",comiis,[_commission doubleValue] * 100];
//        if (comiis + [_monetTd.text doubleValue] > _banlance) {
//            _banlanceLb.text = @"钱包余额不足";
//            _banlanceLb.textColor = [UIColor redColor];
//        }else {
//            _banlanceLb.textColor = UIColorHex(0xC6CFD6);
//        }
    }
}

- (IBAction)payAllBtnDidClick {
    // 全体金额计算
    _getMoney = _banlance / (1 + [_commission doubleValue]);
    double comiis = [_commission doubleValue] * _getMoney;
    _monetTd.text = [NSString stringWithFormat:@"%.2f",_getMoney];
    [self showDesc:NO];
}


- (void)getMoneyHistory{
    DDMoneyHistoryVC * vc = [DDMoneyHistoryVC new];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)cardPictureBtnDidClick {
    [self.view endEditing:YES];
    @weakify(self)
    [self showPhotoActionSheetCompletion:^(bool suc,
                                           NSString *url) {
        @strongify(self)
        if (!self) return ;
        if (suc) {
            [DDHub dismiss:self.view];
            self->_bankURL = url;
            [self.camaraBtn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }else {
            [DDHub hub:@"银行卡正面照上传失败" view:self.view];
        }
        
    }];
}

- (IBAction)showBankListBtnDidClick {
    _bankListView = [DDBankListView createViewFromNib];
    _bankListView.height = (_bankList.count + 2) * 44 + (iPhoneXAfter ? 35 : 0);
    _bankListView.bankList = _bankList;
    _alertController = [TYAlertController alertControllerWithAlertView:_bankListView preferredStyle:TYAlertControllerStyleActionSheet];
    _alertController.backgoundTapDismissEnable = YES;
    @weakify(self)
    _bankListView.event = ^(NSInteger index) {
        @strongify(self)
        if (!self) return ;
        [self.alertController dismissViewControllerAnimated:YES];
        if (index != self->_bankList.count) {
            DDBankModel * model = self->_bankList[index];
            self->_bankURL = model.cardPhoto;
            self.cardNameTd.text = model.userName;
            self.bankNoTd.text = model.bankCardNumber;
            self.bankName.text = model.bankType;
            [self.camaraBtn sd_setImageWithURL:[NSURL URLWithString:model.cardPhoto] forState:UIControlStateNormal];
            self->_isNoBank = NO;
        }else {
            self->_isNoBank = YES;
            self.cardNameTd.text = @"";
            self.bankNoTd.text = @"";
            self.bankName.text = @"";
             self->_bankURL = @"";
            [self.camaraBtn setImage:[UIImage imageNamed:@"icon_camra"] forState:UIControlStateNormal];
        }
        [self updateUI];
    };
    [self presentViewController:_alertController animated:YES completion:nil];
}


// 选择和上传图片
- (void)showPhotoActionSheetCompletion:(void (^)(bool suc ,NSString * url ) )completion{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.configuration.maxSelectCount = 1;
    actionSheet.configuration.maxPreviewCount = 10;
    actionSheet.configuration.navBarColor = [UIColor whiteColor];
    actionSheet.configuration.navTitleColor = UIColorHex(0x193750);
    actionSheet.configuration.allowRecordVideo = NO;
    actionSheet.configuration.allowSelectGif = NO;
    actionSheet.configuration.allowSelectVideo = NO;
    @weakify(self)
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images,
                                       NSArray<PHAsset *> * _Nonnull assets,
                                       BOOL isOriginal) {
        @strongify(self)
        if (!self) return ;
        [self uploadImage:[images firstObject] completion:completion];
    }];
    
    actionSheet.sender = self;
    actionSheet.cancleBlock = ^{
        NSLog(@"取消选择图片");
    };
    [actionSheet showPreviewAnimated:YES];
}

// 上传图片
- (void)uploadImage:(UIImage*)image completion:(void (^)(bool suc ,NSString * url ) )completion{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] path:@"/uas/st/upload"
                        upload:image
                    completion:^(NSInteger code,
                                 NSString *message,
                                 id data) {
                        @strongify(self)
                        if (!self) return ;
                        [DDHub dismiss:self.view];
                        if (code == 200) {
                            if (completion) completion(YES, message);
                            
                        }else {
                            if(completion) completion(NO, nil);
                        }
                    }];
}



@end
