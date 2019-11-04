//
//  DDPaySuccessVC.m
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDPaySuccessVC.h"
#import "DDOrderDetailVc.h"
#import "DDWalletVC.h"
#import "DDOrderPayVC.h"

@interface DDPaySuccessVC (){
    NSTimer * _timer;
    NSInteger _count;
}
@property (weak, nonatomic) IBOutlet UILabel *timePayText;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@end

@implementation DDPaySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付成功";
    
    if (_isWalletPay) {
//        [self getWalletPayCallBack];
    }
    _count = 5;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerScheduled) userInfo:nil repeats:YES];
    
    if (_isComment) {
        _typeLb.text = @"评价提交成功";
        _contentLb.text = @"评价提交成功，您的费用会实时汇进对方账户。感谢使用企业引擎嘀嗒平台";
    }
    
    if (_isBank || _isOrderPay) {
        _typeLb.text = @"提交成功";
        _contentLb.text = @"提交成功,财务部小伙伴正在加紧确认中";
        if (_isOrderChong) {
            _timePayText.text = [NSString stringWithFormat:@"%zdS后跳转到订单支付页",_count];
        }else {
            _timePayText.text = [NSString stringWithFormat:@"%zdS后跳转到钱包页",_count];
        }
        
    }
    
    if (_isReceiptVCPay) {
        _typeLb.text = @"支付成功";
        _contentLb.text = @"恭喜您已经成功支付，嘀嗒平台将尽快为您邮寄纸质发票。";
        _timePayText.text = [NSString stringWithFormat:@"%zdS后跳转到订单页",_count];
    }
    
}

// 处理结果
- (void)getWalletPayCallBack{
//    @weakify(self)
//    [[DDAppNetwork share] get:YES
//                         path:[NSString stringWithFormat:@"/tss/orderpay/walletPayBack?token=%@&orderNumber=%@",[DDUserManager share].user.token,_orderId]
//                         body:@""
//                   completion:^(NSInteger code, NSString *message, NSArray * data) {
//                       @strongify(self)
//                       if(!self) return ;
//                       if (code == 200) {
//
//                       }
//                   }];
}

- (void)timerScheduled{
    _count --;
    if (_count == 0) {
        [_timer invalidate];
        _timer = nil;
        if (_isOrderChong) {
            DDOrderPayVC * vc = [DDOrderPayVC new];
            vc.orderId = _orderId;
            [DDAppManager gotoVC:vc navigtor:self.navigationController];
            return;
        }
        if (_isBank) {
            DDWalletVC * vc = [DDWalletVC new];
            [DDAppManager gotoVC:vc navigtor:self.navigationController];
        }else {
            DDOrderDetailVc * vc = [DDOrderDetailVc new];
            vc.type = 1;
            vc.orderId = _orderId;
            vc.title = @"订单详情";
            [DDAppManager gotoVC:vc navigtor:self.navigationController];
        }
        return;
    }
    if (_isBank || _isOrderPay) {
        if (_isOrderChong) {
            _timePayText.text = [NSString stringWithFormat:@"%zdS后跳转到订单支付页",_count];
        }else {
            _timePayText.text = [NSString stringWithFormat:@"%zdS后跳转到钱包页",_count];
        }
    }else {
        _timePayText.text = [NSString stringWithFormat:@"%zdS后跳转到订单详情页",_count];
    }
    
}

@end
