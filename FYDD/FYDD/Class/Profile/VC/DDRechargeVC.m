//
//  DDRechargeVC.m
//  FYDD
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDRechargeVC.h"
#import "DDPayTypeView.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "DDTransferVC.h"
#import <YYKit/YYKit.h>
#import "DDOrderPayVC.h"

@interface DDRechargeVC (){
    NSString * _limitMoney;
}
@property (weak, nonatomic) IBOutlet UILabel *limitLb;
@property (nonatomic,strong ) TYAlertController * alertController;
@property (weak, nonatomic) IBOutlet UITextField *monetTd;
@property (nonatomic,strong) DDPayTypeView * payTypeView;
@property (weak, nonatomic) IBOutlet UILabel *markTextLb;
@end

@implementation DDRechargeVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlipayNote:) name:AlipayNotifyCationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechartNote:) name:WechatNotifyCationKey object:nil];
    [self getLimitMoney];
}

- (void)getLimitMoney{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:@"/fps/wallet/getRechargeMessage"
                         body:@""
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       [DDHub dismiss:self.view];
                       if (code == 200) {
                           self->_limitMoney = data[@"monetaryLimitation"];
                           self->_markTextLb.text = data[@"remark"];
                           self->_limitLb.text = [NSString stringWithFormat:@"单笔最高充值(%@)",self->_limitMoney];
                       }
                   }];
}

- (IBAction)payBtnDidClick {
    // 获取支付的orderString
    [self.view endEditing:YES];
    NSString * money = self.monetTd.text;
    if (money.length == 0) {
        [DDHub hub:@"请输入充值金额" view:self.view];
        return;
    }
    if ([money integerValue] == 0) {
        [DDHub hub:@"请输入充值金额" view:self.view];
        return;
    }
    if ([money integerValue] > [yyTrimNullText(self->_limitMoney) integerValue]) {
        [DDHub hub:[NSString stringWithFormat:@"单笔最高充值%@",yyTrimNullText(_limitMoney)] view:self.view];
        return;
    }
    
    if (!_alertController){
        _alertController = [TYAlertController alertControllerWithAlertView:self.payTypeView preferredStyle:TYAlertControllerStyleActionSheet];
        _alertController.backgoundTapDismissEnable = YES;
    }
    [self presentViewController:_alertController animated:YES completion:nil];
}

-(DDPayTypeView *)payTypeView{
    if (!_payTypeView) {
        _payTypeView = [DDPayTypeView createViewFromNib];
        _payTypeView.payType = DDAppPayTypeAlipay |  DDAppPayTypeBank | DDAppPayTypeWechat ;
        if (iPhoneXAfter) {
            _payTypeView.height = 250;
        }
        @weakify(self)
        _payTypeView.event = ^(DDAppPayType type) {
            @strongify(self)
            
            [self.alertController dismissViewControllerAnimated:YES];
            NSString * money = self.monetTd.text;
            switch (type) {
                case DDAppPayTypeWallet:
                    break;
                case DDAppPayTypeWechat:
                    [self wechatPay:money];
                    break;
                case DDAppPayTypeBank:
                    [self gotoTransfer:money];
                    break;
                case DDAppPayTypeAlipay:
                    [self aliPay:money];
                    break;
                    
                default:
                    break;
            }
        };
    }
    return _payTypeView;
}

- (void)gotoTransfer:(NSString *)money{
    DDTransferVC  * vc = [DDTransferVC new];
    vc.money = money;
    vc.isChongZhi = YES;
    vc.orderNumber = _orderNumber;
    vc.isOrderChong = _isOrderChong;
    [DDAppManager gotoVC:vc navigtor:self.navigationController];
}

// 支付宝支付
- (void)aliPay:(NSString *)money{
    [self getSignDataRequst:2
                      money:money
                 completion:^(BOOL suc, NSString *sign) {
                     if (suc) {
                         [[AlipaySDK defaultService] payOrder:sign
                                                   fromScheme:DDAppScheme
                                                     callback:^(NSDictionary *resultDic) {
                                                         NSLog(@"reslut = %@",resultDic);
                                                         
                                                         
                                                     }];
                         
                     }
                 }];
    
}

// 微信支付
- (void)wechatPay:(NSString *)money{
    //
    [self getSignDataRequst:3
                      money:money
                 completion:^(BOOL suc, NSString *sign) {
                     if (suc) {
                         
                         // 解析
                         sign= [sign stringByReplacingOccurrencesOfString:@"{" withString:@""];
                         sign= [sign stringByReplacingOccurrencesOfString:@"}" withString:@""];
                         sign= [sign stringByReplacingOccurrencesOfString:@" " withString:@""];
                         NSArray * datas = [sign componentsSeparatedByString:@","];
                         NSString * package = @"";
                         NSString * partnerId = @"";
                         NSString * prepayId = @"";
                         NSString * nonceStr = @"";
                         NSString * stamp = @"";
                         NSString * paysign = @"";
                         for (NSString * key in datas) {
                             if ([key rangeOfString:@"package="].location != NSNotFound){
                                 package = [key stringByReplacingOccurrencesOfString:@"package=" withString:@""];
                             }else if ([key rangeOfString:@"partnerid="].location != NSNotFound){
                                 partnerId = [key stringByReplacingOccurrencesOfString:@"partnerid=" withString:@""];
                             }else if ([key rangeOfString:@"prepayid="].location != NSNotFound){
                                 prepayId = [key stringByReplacingOccurrencesOfString:@"prepayid=" withString:@""];
                             }else if ([key rangeOfString:@"noncestr="].location != NSNotFound){
                                 nonceStr = [key stringByReplacingOccurrencesOfString:@"noncestr=" withString:@""];
                             }else if ([key rangeOfString:@"timestamp="].location != NSNotFound){
                                 stamp = [key stringByReplacingOccurrencesOfString:@"timestamp=" withString:@""];
                             }else if ([key rangeOfString:@"paysign="].location != NSNotFound){
                                 paysign = [key stringByReplacingOccurrencesOfString:@"paysign=" withString:@""];
                             }
                         }
                         
                         PayReq *req   = [[PayReq alloc] init];
                         //                         req.openID = [DDUserManager share].user.wechatOpenid;
                         req.partnerId = partnerId;
                         req.prepayId  = prepayId;
                         req.package  = package;
                         req.nonceStr  = nonceStr;
                         req.timeStamp = stamp.intValue;
                         req.sign = paysign;
                         [WXApi sendReq:req];
                     }
                 }];
}

// 获取后台返回的签名数据
- (void)getSignDataRequst:(NSInteger)type
                    money:(NSString *)money
               completion:(void (^)(BOOL suc ,id sign))completion{
    NSString * body = [NSString stringWithFormat:@"{\"amountMoney\" : \"%@\" , \"payType\" : %zd }",money,type];
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/fps/wallet/payment/torecharge?token=",
                                       [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           if (completion){
                               completion(YES,data[@"bodyString"]);
                           }
                           [DDHub dismiss:self.view];
                       }else {
                           [DDHub hub:message view:self.view];
                           if (completion){
                               completion(NO,nil);
                           }
                       }
                   }];
}

- (void)AlipayNote:(NSNotification *)note{
    NSInteger status = [note.object integerValue];
    if (status == 9000) {
        [DDHub hub:@"充值成功" view:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(1.5 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            if (self->_orderNumber) {
                DDOrderPayVC * vc = [DDOrderPayVC new];
                vc.orderId = self.orderNumber;
                [DDAppManager gotoVC:vc navigtor:self.navigationController];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    }else if (status == 8000) {
        [DDHub hub:@"充值正在处理中" view:self.view];
    }else if (status == 6001) {
        [DDHub hub:@"您取消了充值" view:self.view];
    }else {
        [DDHub hub:@"充值失败" view:self.view];
    }
}

- (void)wechartNote:(NSNotification *)note{
    NSInteger status = [note.object integerValue];
    switch (status) {
        case 0:{
            [DDHub hub:@"充值成功" view:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                         (int64_t)(1.5 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                if (self->_orderNumber) {
                    DDOrderPayVC * vc = [DDOrderPayVC new];
                    vc.orderId = self.orderNumber;
                    [DDAppManager gotoVC:vc navigtor:self.navigationController];
                }else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        } break;
        case -1:
            [DDHub hub:@"充值失败" view:self.view];
            break;
        case -2:
            [DDHub hub:@"您取消了充值" view:self.view];
            break;
        default:
            [DDHub hub:@"充值失败" view:self.view];
            break;
    }
}
@end
