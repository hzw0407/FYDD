//
//  DDOrderPayVC.m
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderPayVC.h"
#import "DDOrderPayTypeCell.h"
#import "DDOrderPayInfoCell.h"

#import "DDPaySuccessVC.h"
#import "DDTransferVC.h"
#import "DDOrderDetailInfo.h"
#import "DDAlertView.h"
#import "DDPayPasswordVC.h"
#import "DDAlertInputView.h"
#import "DDGetMoneyPasswordView.h"
#import "UIView+TYAlertView.h"
#import "DDPayTypeView.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "DDOrderCPICell.h"
#import "DDOrderCompanyInfoCell.h"
#import "DDWebVC.h"
#import "DDRechargeVC.h"

@interface DDOrderPayVC ()<UITableViewDelegate,UITableViewDataSource>{
    DDOrderDetailInfo * _orderInfo;
    // 代理码
    NSString * _member;
    NSString * _city;
    NSInteger _applyStatus;
    NSInteger _apply2Status;
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) DDGetMoneyPasswordView * payPasswordView;
@property (nonatomic,strong) DDPayTypeView * payTypeView;
@property (nonatomic,strong ) TYAlertController * alertController;


@end

@implementation DDOrderPayVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单确认";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    self.navigationItem.rightBarButtonItem.tintColor = UIColorHex(0xFBB730);
    [self getSignStatus:nil];
}

// 获取签署状态
- (void)getSignStatus:(void (^)(void))completioon{
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/tss/orders/getJunziqianStatusByOrder?orderNumber=", _orderId)
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       if (code == 200) {
                           self->_applyStatus = [data[@"applyStatus"] integerValue];
                           self->_apply2Status = [data[@"apply2Status"] integerValue];
                           [self.tableView reloadData];
                       }
                       if (completioon)
                           completioon();
                   }];
}

- (void)cancelBtnDidClick{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"%@&token=%@",YYFormat(@"/tss/orders/setOrdersCancel?orderNumber=", _orderId),[DDUserManager share].user.token]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       [DDHub dismiss:self.view];
                       if (code == 200) {
                           [self.navigationController popToRootViewControllerAnimated:YES];
                       }
                   }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getOrderInfoData];
}

// 获取订单信息
- (void)getOrderInfoData{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"%@&token=%@",YYFormat(@"/tss/orders/getOrderInfo?orderNumber=", _orderId),[DDUserManager share].user.token]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       [DDHub dismiss:self.view];
                       if (code == 200) {
                           self->_orderInfo = [DDOrderDetailInfo modelWithJSON:data];
                           self->_city = [[DDAppManager share] getCityCode:self->_orderInfo.orders.orderArea];
                           if (!self->_orderInfo.orders.isRenew) {
                               self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnDidClick)];
                           }
                           [self.tableView reloadData];
                       }
                   }];
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorHex(0xEFEFF6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDOrderPayTypeCell" bundle:nil] forCellReuseIdentifier:@"DDOrderPayTypeCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDOrderCPICell" bundle:nil] forCellReuseIdentifier:@"DDOrderCPICellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDOrderCompanyInfoCell" bundle:nil] forCellReuseIdentifier:@"DDOrderCompanyInfoCellId"];
    }
    return _tableView;
}


- (void)gotoPay{
    [self getSignStatus:^{
        if (self->_applyStatus != 1) {
            [DDHub hub:@"请签署服务协议" view:self.view];
            return ;
        }
        if (self->_applyStatus != 1) {
            [DDHub hub:@"请签署保密协议" view:self.view];
            return ;
        }
        [self getSignStatus:^{
            
        }];
        if (!self.alertController){
            self.alertController = [TYAlertController alertControllerWithAlertView:self.payTypeView preferredStyle:TYAlertControllerStyleActionSheet];
            self.alertController.backgoundTapDismissEnable = YES;
        }
        [self presentViewController:self.alertController animated:YES completion:nil];
    }];
}

-(DDPayTypeView *)payTypeView{
    if (!_payTypeView) {
        _payTypeView = [DDPayTypeView createViewFromNib];
        _payTypeView.payType = DDAppPayTypeAlipay |  DDAppPayTypeBank | DDAppPayTypeWechat | DDAppPayTypeWallet ;
        if (iPhoneXAfter) {
            _payTypeView.height = 250;
        }
        @weakify(self)
        _payTypeView.event = ^(DDAppPayType type) {
            @strongify(self)
            [self.alertController dismissViewControllerAnimated:YES];
            switch (type) {
                case DDAppPayTypeWallet:
                    [self getWalletPay];
                    break;
                case DDAppPayTypeWechat:
                    [self wechatPay];
                    break;
                case DDAppPayTypeBank:{
                    [self gotoTransfer];
                }break;
                case DDAppPayTypeAlipay:
                    [self aliPay];
                    break;
                    
                default:
                    break;
            }
        };
    }
    return _payTypeView;
}


- (void)gotoTransfer{
    DDTransferVC  * vc = [DDTransferVC new];
    vc.orderNumber = _orderId;
    vc.isOrderPay = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 支付宝支付
- (void)aliPay{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlipayNote:) name:AlipayNotifyCationKey object:nil];
    [self getSignDataRequst:2
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

- (void)AlipayNote:(NSNotification *)note{
    NSInteger status = [note.object integerValue];
    if (status == 9000) {
        DDPaySuccessVC * vc = [DDPaySuccessVC new];
        vc.orderId = self.orderId;
        [DDAppManager gotoVC:vc navigtor:self.navigationController];
    }else if (status == 8000) {
        [DDHub hub:@"付款正在处理中" view:self.view];
    }else if (status == 6001) {
        [DDHub hub:@"您取消了付款" view:self.view];
    }else {
        [DDHub hub:@"付款失败" view:self.view];
    }
}


- (void)wechartNote:(NSNotification *)note{
    NSInteger status = [note.object integerValue];
    switch (status) {
            case 0:{
                DDPaySuccessVC * vc = [DDPaySuccessVC new];
                vc.orderId = self.orderId;
                [DDAppManager gotoVC:vc navigtor:self.navigationController];
            } break;
            case -1:
            [DDHub hub:@"付款失败" view:self.view];
            break;
            case -2:
            [DDHub hub:@"您取消了付款" view:self.view];
            break;
        default:
            [DDHub hub:@"付款失败" view:self.view];
            break;
    }
}

#pragma mark - 微信支付
- (void)wechatPay{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechartNote:) name:WechatNotifyCationKey object:nil];
    [self getSignDataRequst:3
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
               completion:(void (^)(BOOL suc ,id sign))completion{
    NSString * body = [NSString stringWithFormat:@"{\"orderNumber\" : \"%@\" , \"payType\" : %zd }",_orderInfo.orders.orderNumber,type];
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/tss/orderpay/orderPayment?token=",
                                       [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           if (completion){
                               completion(YES,data);
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


#define mark - 钱包支付
- (void)getWalletPay{
    @weakify(self)
    [DDHub hub:self.view];
    [[DDUserManager share] getUserPayPasswordStateCompletion:^(BOOL suc) {
        @strongify(self)
        if (!self) return ;
        // 判断是否这是支付密码
         [DDHub dismiss:self.view];
        if (!suc) {
            [DDAlertView showTitle:@"温馨提示"
                          subTitle:@"您未设置支付密码！"
                       actionName1:@"去设置"
                       actionName2:@"取消" sureEvent:^{
                           DDPayPasswordVC * vc = [DDPayPasswordVC new];
                             [DDAppManager gotoVC:vc navigtor:self.navigationController];
                       } cancelEvent:^{
                           
                       }];
        }else {
            self->_member = @"";
            [self showPayPassword];
            /*
            // 直接跳转出支付页面
            if (self->_orderInfo.orders.extensionMember != 0 || self->_orderInfo.orders.isRenew) {
                [self showPayPassword];
            // 填写代理码
            }else{
                [DDAlertInputView showEvent:^(NSString *text) {
                    self->_member = text;
                    [DDHub hub:self.view];
                    [[DDAppNetwork share] get:YES
                                         path:[NSString stringWithFormat:@"/tss/orders/setOrdersExtension?orderNumber=%@&extensionCode=%@",self->_orderInfo.orders.orderNumber,text]
                                         body:@""
                                   completion:^(NSInteger code, NSString *message, id data) {
                                       @strongify(self)
                                       if (!self) return ;
                                       [DDHub dismiss:self.view];
                                       if (code == 200) {
                                          [self showPayPassword];
                                       }else {
                                        [DDHub hub:message view:self.view];
                                       }
                                   }];
                   
                } cancelEvent:^{
                    [self showPayPassword];
                }];
            }
            */
        }
    }];

}

- (void)showPayPassword{
    _payPasswordView = [DDGetMoneyPasswordView createViewFromNib];
    if (iPhoneXAfter) {
        _payPasswordView.height = 220;
    }
    _payPasswordView.title = @"钱包购买产品";
    _payPasswordView.money = _orderInfo.orders.paymentAmount;
    @weakify(self)
    [_payPasswordView showFrom:self
                    completion:^(NSString *text) {
                        @strongify(self)
                        if (!self) return ;
                        [self payRequest:text];
    }];
}

- (void)payRequest:(NSString *)password{
    @weakify(self)
    NSString * body = [NSString stringWithFormat:@"{\"orderNumber\" : \"%@\" , \"payType\" : 1 , \"payPassword\" : \"%@\"}",_orderInfo.orders.orderNumber,password];
    [DDHub hub:self.view];
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/tss/orderpay/orderPayment?token=", [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                            DDPaySuccessVC * vc = [DDPaySuccessVC  new];
                            vc.orderId = self->_orderInfo.orders.orderNumber;
                            [DDAppManager gotoVC:vc navigtor:self.navigationController];
                       }else {
                           if (code == 2101) {
                               [DDAlertView showTitle:@"温馨提示"
                                             subTitle:@"余额不足！"
                                          actionName1:@"去充值"
                                          actionName2:@"取消" sureEvent:^{
                                              DDRechargeVC * vc = [DDRechargeVC new];
                                              vc.orderNumber = self.orderId;
                                              vc.isOrderChong = YES;
                                              [DDHub dismiss:self.view];
                                              [self.navigationController pushViewController:vc animated:YES];
                                          } cancelEvent:^{
                                              [DDHub dismiss:self.view];
                                          }];
                           }else {
                               [DDHub hub:message view:self.view];
                           }
                       }
                   }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DDOrderCPICell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderCPICellId"];
        cell.info = _orderInfo;
        return cell;
    }else {
        @weakify(self)
        DDOrderCompanyInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderCompanyInfoCellId"];
        cell.nameLb.text = [NSString stringWithFormat:@"我方实施联系人: %@",_orderInfo.orders.userLinkman];
        cell.phoneLb.text = [NSString stringWithFormat:@"联系方式: %@",_orderInfo.orders.userLinkmanPhone];
        cell.companyLb.text = yyTrimNullText([DDUserManager share].user.enterpriseName);
        cell.cityLv.text = [NSString stringWithFormat:@"%@",_city];
        [cell.btn1 setTitle:_applyStatus == 0 ? @"签署" : @"查看" forState:UIControlStateNormal];
        [cell.btn2 setTitle:_apply2Status == 0 ? @"签署" : @"查看" forState:UIControlStateNormal];
        cell.topView.hidden = _orderInfo.orders.isRenew;
        cell.consTop.constant = _orderInfo.orders.isRenew ? 10 : 110;
        cell.event = ^(NSInteger index) {
            @strongify(self)
            if (index == 2) {
                [self gotoPay];
            }else if (index == 0) {
                [self signHetong];
            }else if (index == 1) {
                [self signHetong2];
            }
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return 230;
    if (indexPath.row == 1){
        return _orderInfo.orders.isRenew ? 304 : 404;
    }
    return 30;
}

- (void)signHetong{
    @weakify(self)
    [DDHub hub:self.view];
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/tss/junziqian/apply?token=%@&orderNo=%@",[DDUserManager share].user.token,_orderId]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                        @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           DDWebVC * vc = [DDWebVC new];
                           vc.url = message;
                           vc.title = @"签署服务协议";
                           [self.navigationController pushViewController:vc animated:YES];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

- (void)signHetong2{
    @weakify(self)
    [DDHub hub:self.view];
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/tss/junziqian/apply2?token=%@&orderNo=%@",[DDUserManager share].user.token,_orderId]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           DDWebVC * vc = [DDWebVC new];
                           vc.url = message;
                           vc.title = @"签署服务协议";
                           [self.navigationController pushViewController:vc animated:YES];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

@end
