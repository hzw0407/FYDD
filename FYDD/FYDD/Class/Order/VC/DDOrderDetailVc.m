//
//  DDOrderDetailVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderDetailVc.h"
#import "DDOrderDetailObj.h"
#import "DDOrderStatusCell.h"
#import "DDOrderHeaderView.h"
#import "DDOrderNumberCell.h"
#import "DDOrderProductDataInfoCell.h"
#import "DDOrderEffectCell.h"
#import "DDOrderCompanyCell.h"
#import "DDAlertView.h"
#import "BRDatePickerView.h"
#import <FSCalendar/FSCalendar.h>
#import "DDCommentVC.h"
#import "UIView+TYAlertView.h"
#import "DDPayTypeView.h"
#import "DDTransferVC.h"
#import "DDPayPasswordVC.h"
#import "DDAlertInputView.h"
#import "DDGetMoneyPasswordView.h"
#import "DDPaySuccessVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WechatOpenSDK/WXApi.h>
#import "DDOrderPlanModel.h"
#import "DDOrderImplementationStepCell.h"
#import "YYPhotoGroupView.h"
#import <YYKit/YYKit.h>
#import "DDOrderStepMenuView.h"
#import "DDComfimOrderStepVc.h"
#import "DDStepRejectView.h"
#import "DDCommitStepVc.h"
#import "DDChangeCarryUserVcViewController.h"

#import "DDOrderVC.h"
@interface DDOrderDetailVc () <UITableViewDelegate,UITableViewDataSource> {
    NSString * _member;
    NSArray * _planModels; // 计划步骤
    DDOrderPlanModel * _currentPlan; // 当前计划步骤
    
    BOOL _expandPlan;  // 收缩实施计划
    BOOL _isNeedPlan;  // 是否需要展示计划
}
@property (nonatomic,strong) DDOrderDetailObj * order;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *orderBarView;
@property (weak, nonatomic) IBOutlet UIButton *orderMenuButton1;
@property (weak, nonatomic) IBOutlet UIButton *orderMenuButton2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barViewCons;
@property (nonatomic,strong) DDPayTypeView * payTypeView;
@property (nonatomic,strong ) TYAlertController * alertController;
@property (nonatomic,strong) DDGetMoneyPasswordView * payPasswordView;
@property (weak, nonatomic) IBOutlet UIView *payButtonView;
@end

@implementation DDOrderDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
//    [self getOrderData];
    
    _expandPlan = NO;
    _orderBarView.hidden = YES;
    _barViewCons.constant = iPhoneXAfter ? 70 : 50;
    [self.tableView registerNib:[UINib nibWithNibName:@"DDOrderStatusCell" bundle:nil] forCellReuseIdentifier:@"DDOrderStatusCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DDOrderNumberCell" bundle:nil] forCellReuseIdentifier:@"DDOrderNumberCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DDOrderProductDataInfoCell" bundle:nil] forCellReuseIdentifier:@"DDOrderProductDataInfoCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DDOrderEffectCell" bundle:nil] forCellReuseIdentifier:@"DDOrderEffectCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DDOrderCompanyCell" bundle:nil] forCellReuseIdentifier:@"DDOrderCompanyCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DDOrderImplementationStepCell" bundle:nil] forCellReuseIdentifier:@"DDOrderImplementationStepCellId"];
    // DDOrderImplementationStepCell
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVc)];
    
}


- (void)dismissVc{
    DDOrderVC * order = [DDOrderVC new];
    order.title = @"订单";
    [DDAppManager gotoVC:order navigtor:self.navigationController animated:NO];
}

- (void)setupUI{
    _orderBarView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.20].CGColor;
    _orderBarView.layer.shadowOffset = CGSizeMake(0,6);
    _orderBarView.layer.shadowRadius = 22;
    _orderBarView.layer.shadowOpacity = 1;
}
- (IBAction)cancelButtonDidClick:(id)sender {
    [self cancelOrder];
}
- (IBAction)payButtonDidClick:(id)sender {
    [self gotoPay];
}

- (void)getOrderData{
    [DDHub hub:self.view];
    NSString * url = [NSString stringWithFormat:@"%@:%@/tss/orders/getOrderInfoNew",DDAPP_URL,DDPort7001];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                          url:url
                   parameters:@{
                                @"token" : [DDUserManager share].user.token,
                                @"orderNumber" : yyTrimNullText(_orderId),
                                }
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           self.order = [DDOrderDetailObj modelWithJSON:data];
                           [self getImplementPlan];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                       [self.tableView reloadData];
                   }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getOrderData];
//    [self getImplementPlan];
}


- (void)getImplementPlan{
    if (!self.order) return;
    @weakify(self)
    [[DDAppNetwork share] get:YES
                          url:[NSString stringWithFormat:@"%@/onlineplan/detail/orderPlanDetail",DDAPP_URL]
                   parameters:@{
                                @"planId" : self.order.implementPlanId,
                                @"orderNumber" : yyTrimNullText(_orderId),
                                }
                   completion:^(NSInteger code, NSString *message, NSArray * data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           if (data && [data isKindOfClass:[NSArray class]]) {
                               NSMutableArray * plans = @[].mutableCopy;
                               self->_planModels = nil;
                               self->_currentPlan = nil;
                               for (NSInteger i =0; i < data.count; i++) {
                                   DDOrderPlanModel * planModel = [DDOrderPlanModel modelWithJSON:data[i]];
                                   if (![yyTrimNullText(planModel.status) isEqualToString:@"1"] && !self->_currentPlan) {
                                       self->_currentPlan = planModel;
                                   }
                                   planModel.step = i + 1;
                                   [planModel layoutCons];
                                   [plans addObject:planModel];
                               }
                               self->_planModels = plans;
                           }
                           [self updateUI];
                           [self.tableView reloadData];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                       [self.tableView reloadData];
                   }];
}


- (void)updateUI{
    _payButtonView.hidden = YES;
    switch (_order.orderStatusType) {
        case DDOrderStatusCarry:
        case DDOrderStatusChangeCarryUser:
        case DDOrderStatusWaitComment:
        case DDOrderStatusFinish:
            _isNeedPlan = YES;
            break;
        case DDOrderStatusPay:
        case DDOrderStatusWaitPay:
        case DDOrderStatusPayFail:
            if (_order.isCompanyFirst) {
                _isNeedPlan = YES;
            }
            break;
        
        default:
            break;
    }
    
    BOOL hiddenBar = YES;
    switch (self.type) {
            
        case 2:
            break;
        case 1:
            // 待评价
            if (_order.orderStatusType == DDOrderStatusWaitComment){
                hiddenBar = NO;
                _orderMenuButton1.tag = 1000;
                [_orderMenuButton1 setTitle:@"试用期间免费" forState:UIControlStateNormal];
                [_orderMenuButton2 setTitle:@"评价" forState:UIControlStateNormal];
                _orderMenuButton2.tag = 2;
                // 待支付
            }else if (_order.orderStatusType == DDOrderStatusWaitPay ||
                      _order.orderStatusType == DDOrderStatusPayFail) {
                _payButtonView.hidden = NO;
                hiddenBar = NO;
                _orderMenuButton2.tag = 3;
                _orderMenuButton1.hidden = YES;
                [_orderMenuButton2 setTitle:@"支付" forState:UIControlStateNormal];
                if (_order.isCompanyFirst == 1) {
                    //首次下单
                    _payButtonView.hidden = YES;
                    _orderMenuButton1.hidden = NO;
                    [_orderMenuButton1 setTitle:@"试用期间免费" forState:UIControlStateNormal];
                    [_orderMenuButton2 setTitle:@"付款永久使用" forState:UIControlStateNormal];
                }else {
                    //不是首次下单 直接调起支付
                    [self gotoPay];
                }
            }else if (_order.orderStatusType == DDOrderStatusPay) {
                hiddenBar = NO;
                _orderMenuButton2.hidden = YES;
                _orderMenuButton1.centerX = kScreenSize.width * 0.5;
                [_orderMenuButton1 setTitle:@"支付中" forState:UIControlStateNormal];
            }else if (_order.orderStatusType == DDOrderStatusCarry) {
                _orderMenuButton2.tag = 4;
                NSArray *array = [_order.orderPlanSequence componentsSeparatedByString:@";"];
                if (array.count > 0) {
                    //已经开始实施
                    if (_order.implementPlanDetailSeq > [array[0] integerValue]) {
                        //当前步骤大于限制的步骤
                        _orderMenuButton1.hidden = YES;
                        _orderMenuButton2.hidden = YES;
                    }else {
                        //小于限制的步骤
                        _orderMenuButton1.hidden = NO;
                        _orderMenuButton2.hidden = NO;
                        [_orderMenuButton1 setTitle:@"试用期间免费" forState:UIControlStateNormal];
                        [_orderMenuButton2 setTitle:@"更换实施员" forState:UIControlStateNormal];
                    }
                }else {
                    //还未实施
                    _orderMenuButton1.hidden = NO;
                    _orderMenuButton2.hidden = NO;
                    [_orderMenuButton1 setTitle:@"试用期间免费" forState:UIControlStateNormal];
                    [_orderMenuButton2 setTitle:@"更换实施员" forState:UIControlStateNormal];
                }
                hiddenBar = NO;
            }else if (_order.orderStatusType == DDOrderStatusChangeCarryUser) {
                _orderMenuButton2.tag = 1000;
                _orderMenuButton1.tag = 1000;
                [_orderMenuButton1 setTitle:@"试用期间免费" forState:UIControlStateNormal];
                _orderMenuButton2.backgroundColor = UIColorHex(0x9A9A9A);
                [_orderMenuButton2 setTitle:@"正在更换实施员" forState:UIControlStateNormal];
                hiddenBar = NO;
            }else if (_order.orderStatusType == DDOrderStatusFinish) {
                hiddenBar = YES;
            }else if (_order.orderStatusType == DDOrderWaitReceipt || _order.orderStatusType == DDOrderStatusLeaflets) {
                //待接单、派单中
                if (_order.isCompanyFirst == 0) {
                    //不是首次下单
                    hiddenBar = YES;
                }else {
                    //首次下单
                    hiddenBar = NO;
                    _orderMenuButton1.tag = 1000;
                    _orderMenuButton2.tag = 5;
                    [_orderMenuButton1 setTitle:@"试用期间免费" forState:UIControlStateNormal];
                    [_orderMenuButton2 setTitle:@"取消订单" forState:UIControlStateNormal];
                }
            }
//            else if (_order.orderStatusType == DDOrderStatusService ||
//                      _order.orderStatusType == DDOrderStatusLeaflets) {
//                if (!_order.isCompanyFirst && _order.orderStatusType ==  DDOrderStatusLeaflets) {
//                    return;
//                }
//                hiddenBar = NO;
//                _orderMenuButton1.tag = 1000;
//                _orderMenuButton2.tag = 5;
//                [_orderMenuButton1 setTitle:@"试用期间免费" forState:UIControlStateNormal];
//                [_orderMenuButton2 setTitle:@"取消订单" forState:UIControlStateNormal];
//            }

            break;
            // 实施员
        case 3:{
            // 当前待接单状态
            if (_order.orderStatusType == DDOrderStatusOrderTaking ||
                _order.orderStatusType == DDOrderStatusLeaflets ||
                _order.orderStatusType == DDOrderStatusPaySuccess) {
                hiddenBar = NO;
                [_orderMenuButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_orderMenuButton1 setTitle:@"拒绝" forState:UIControlStateNormal];
                [_orderMenuButton2 setTitle:@"接受" forState:UIControlStateNormal];
                _orderMenuButton1.backgroundColor = [DDAppManager share].appTintColor;
                _orderMenuButton1.alpha = 0.7;
                _orderMenuButton1.tag = 0;
                _orderMenuButton2.tag = 1;
            }else if (_order.orderStatusType == DDOrderStatusCarry ||
                      _order.orderStatusType == DDOrderStatusService) {
                BOOL isExamine = NO;
                _orderMenuButton1.backgroundColor = [UIColor whiteColor];
                [_orderMenuButton1 setTitleColor:UIColorHex(0xEF8200) forState:UIControlStateNormal];
                for (DDOrderPlanModel * planModel  in _planModels) {
                    if (yyTrimNullText(planModel.status).length && [yyTrimNullText(planModel.status) integerValue] == 0) {
                        isExamine = YES;
                    }
                }
                [_orderMenuButton1 setTitle:@"" forState:UIControlStateNormal];
                [_orderMenuButton2 setTitle:isExamine ? @"审核中" : @"上传实施步骤" forState:UIControlStateNormal];
                _orderMenuButton1.tag = 6;
                _orderMenuButton2.tag = isExamine ? 1000 : 7;
                _orderMenuButton2.backgroundColor = isExamine ? UIColorHex(0x9A9A9A) : [DDAppManager share].appTintColor;
                hiddenBar = NO;
            }else if (_order.orderStatusType == DDOrderStatusChangeCarryUser) {
                _orderMenuButton1.backgroundColor = [UIColor whiteColor];
                [_orderMenuButton1 setTitleColor:UIColorHex(0xEF8200) forState:UIControlStateNormal];
                [_orderMenuButton1 setTitle:@"" forState:UIControlStateNormal];
                [_orderMenuButton2 setTitle:@"更改实施中" forState:UIControlStateNormal];
                _orderMenuButton1.tag = 6;
                _orderMenuButton2.tag = 1000;
                _orderMenuButton2.backgroundColor =  UIColorHex(0x9A9A9A);
                hiddenBar = NO;
            }
        }break;
        default:
            break;
    }
    _orderBarView.hidden = hiddenBar;
}

- (IBAction)bottomBarDidClick:(UIButton *)sender {
        // 拒绝接单
    if (sender.tag == 0) {
        [DDAlertView showTitle:@"提示"
                      subTitle:@"您确定拒绝该订单?"
                     sureEvent:^{
                         [self trefuseOrder];
                     } cancelEvent:^{
                         
                     }];
        // 接受接单
    }else if (sender.tag == 1) {
        @weakify(self)
        [BRDatePickerView showDatePickerWithTitle:@"选择服务开始时间"
                                         dateType:BRDatePickerModeYMD
                                  defaultSelValue:@""
                                          minDate:[NSDate dateWithTimeIntervalSince1970:_order.dispatchDate / 1000] maxDate:nil
                                     isAutoSelect:NO
                                       themeColor:nil resultBlock:^(NSString *selectValue) {
                                           @strongify(self)
                                           [self takeOrders:selectValue];
                                       }];
        // 评价订单
    }else if (sender.tag == 2) {
        DDCommentVC * vc = [DDCommentVC new];
        vc.orderNumber = _order.orderNumber;
        vc.name = _order.extensionName;
        vc.name1 = _order.implementName;
        vc.orderId = _order.orderId;
        [self.navigationController pushViewController:vc animated:YES];
        // 支付
    }else if (sender.tag == 3) {
        [self gotoPay];
        // 更换实施员
    }else if (sender.tag == 4) {
        [self changeCarryUser];
        // 取消订单
    }else if (sender.tag == 5) {
        [self cancelOrder];
        // 讲解交流
    }else if (sender.tag == 6) {
        // 上传实施步骤
    }else if (sender.tag == 7) {
        [self commitCarryData];
    }
}

// 取消订单
- (void)cancelOrder{
    [DDAlertView showTitle:@"提示"
                  subTitle:@"您确定取消该订单?"
                 sureEvent:^{
                     [DDHub hub:self.view];
                     NSString * url = [NSString stringWithFormat:@"%@:%@/tss/orders/setOrdersCancel",DDAPP_URL,DDPort7001];
                     @weakify(self)
                     [[DDAppNetwork share] get:YES
                                           url:url
                                    parameters:@{
                                                 @"token" : [DDUserManager share].user.token,
                                                 @"orderNumber" : yyTrimNullText(_orderId),
                                                 }
                                    completion:^(NSInteger code, NSString *message, id data) {
                                        @strongify(self)
                                        if (!self) return ;
                                        if (code == 200) {
                                            [DDHub hub:@"取消成功" view:self.view];
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [self.navigationController popViewControllerAnimated:YES];
                                            });
                                        }else {
                                            [DDHub hub:message view:self.view];
                                        }
                                        [self.tableView reloadData];
                                    }];
                 } cancelEvent:^{
                     
                 }];
    

}


// 更换实施员
- (void)changeCarryUser{
    DDChangeCarryUserVcViewController * vc = [DDChangeCarryUserVcViewController new];
    vc.order = self.order;
    vc.plans = _planModels;
    [self.navigationController pushViewController:vc animated:YES];
}

// 上传实施步骤
- (void)commitCarryData{
    DDCommitStepVc * vc = [DDCommitStepVc new];
    vc.planModel = _currentPlan;
    vc.order = self.order;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoPay{
    if (!_alertController){
        _alertController = [TYAlertController alertControllerWithAlertView:self.payTypeView preferredStyle:TYAlertControllerStyleActionSheet];
        _alertController.backgoundTapDismissEnable = YES;
    }
    [self presentViewController:_alertController animated:YES completion:nil];
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
                    DDTransferVC * vc = [DDTransferVC new];
                    vc.orderNumber = self.orderId;
                    [self.navigationController pushViewController:vc animated:YES];
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

- (NSString *)getDateFormat:(NSString *)date{
    if (yyTrimNullText(date).length == 0) {
        return @"";
    }
    NSArray * dateLists = [date componentsSeparatedByString:@" "];
    if (dateLists.count) {
        return dateLists[0];
    }
    return @"";
}

- (void)trefuseOrder{
    [DDHub hub:self.view];
    NSString * body = [NSString stringWithFormat:@"{\"orderNumber\" : \"%@\"}",_order.orderNumber];
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/tss/orders/refuseOrder?token=", [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           [self.navigationController popViewControllerAnimated:YES];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

- (void)takeOrders:(NSString *)date{
    [DDHub hub:self.view];
    NSString * body = [NSString stringWithFormat:@"{\"dateStr\" : \"%@\"  , \"orderNumber\" : \"%@\"}",date,_order.orderNumber];
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/tss/orders/takeOrders?token=", [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           [self getOrderData];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

#pragma mark - 钱包支付
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
                           [self.navigationController pushViewController:vc animated:YES];
                       } cancelEvent:^{
                           
                       }];
        }else {
            self->_member = @"";
            [self showPayPassword];
//            // 直接跳转出支付页面
//            if (self.order.extensionMember != 0 ) {
//
//                // 填写代理码
//            }else{
//                [DDAlertInputView showEvent:^(NSString *text) {
//                    self->_member = text;
//                    [DDHub hub:self.view];
//                    [[DDAppNetwork share] get:YES
//                                         path:[NSString stringWithFormat:@"/tss/orders/setOrdersExtension?orderNumber=%@&extensionCode=%@",self.order.orderNumber,text]
//                                         body:@""
//                                   completion:^(NSInteger code, NSString *message, id data) {
//                                       @strongify(self)
//                                       if (!self) return ;
//                                       [DDHub dismiss:self.view];
//                                       if (code == 200) {
//                                           [self getOrderData];
//                                           [self showPayPassword];
//                                       }else {
//                                           [DDHub hub:message view:self.view];
//                                       }
//                                   }];
//
//                } cancelEvent:^{
//                    [self showPayPassword];
//                }];
//            }
            
        }
    }];
    
}

// 钱包支付输入密码
- (void)showPayPassword{
    _payPasswordView = [DDGetMoneyPasswordView createViewFromNib];
    if (iPhoneXAfter) {
        _payPasswordView.height = 220;
    }
    _payPasswordView.title = @"订单支付";
    _payPasswordView.money = self.order.implementationCost + [self.order.accountNumberPrice doubleValue];
    @weakify(self)
    [_payPasswordView showFrom:self
                    completion:^(NSString *text) {
                        @strongify(self)
                        if (!self) return ;
                        [self payRequest:text];
                    }];
}

// 钱包支付请求
- (void)payRequest:(NSString *)password{
    @weakify(self)
    NSString * body = [NSString stringWithFormat:@"{\"orderNumber\" : \"%@\" , \"payType\" : 1 , \"payPassword\" : \"%@\"}",_order.orderNumber,password];
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
                           vc.isWalletPay = YES;
                           vc.orderId = self.orderId;
                           [DDAppManager gotoVC:vc navigtor:self.navigationController];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}


#pragma mark - 微信支付
- (void)wechatPay{
    [self getSignDataRequst:3
                 completion:^(BOOL suc, NSString *sign) {
                     if (suc) {
                         PayReq *req   = [[PayReq alloc] init];
                         req.openID = @"";
                         req.partnerId = @"";
                         req.prepayId  = @"";
                         req.package  = @"";
                         req.nonceStr  = @"";
                         NSString * stamp = @"";
                         req.timeStamp = stamp.intValue;
                         req.sign = @"";
                         [WXApi sendReq:req];
                     }
                 }];
}

// 获取后台返回的签名数据
- (void)getSignDataRequst:(NSInteger)type
               completion:(void (^)(BOOL suc ,id sign))completion{
    NSString * body = [NSString stringWithFormat:@"{\"orderNumber\" : \"%@\" , \"payType\" : %zd }",_orderId,type];
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

#pragma mark - 支付宝支付
- (void)aliPay{
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
        [DDHub hub:@"充值成功" view:self.view];
        [self getOrderData];
    }else if (status == 8000) {
        [DDHub hub:@"充值正在处理中" view:self.view];
    }else if (status == 6001) {
        [DDHub hub:@"您取消了充值" view:self.view];
    }else {
        [DDHub hub:@"充值失败" view:self.view];
    }
}


// 审核实施步骤
- (void)comfirmStep{
    @weakify(self)
    [DDOrderStepMenuView show:^(BOOL isAgree) {
        @strongify(self)
        if (isAgree) {
            DDComfimOrderStepVc * vc = [DDComfimOrderStepVc new];
            vc.order = self.order;
            vc.planModel = self->_currentPlan;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [DDStepRejectView show:^(NSString * _Nonnull
                                     message) {
                NSDictionary * dic= @{
                                      
                                      @"orderNumber " : self.order.orderNumber,
                                      @"status" : @(2),
                                      @"userDetail" : yyTrimNullText(message),
                                      @"id" :self->_currentPlan.orderDetailId,
                                      };
                @weakify(self)
                [[DDAppNetwork share] get:NO path:[NSString stringWithFormat:@"/t-phase/onlineplan/orderdetail/update?token=%@",[DDUserManager share].user.token] body:[dic modelToJSONString] completion:^(NSInteger code, NSString *message, id data) {
                    @strongify(self)
                    if (!self) return ;
                    if(code == 200) {
                        [DDHub dismiss:self.view];
                        [self getOrderData];
                    }else {
                        [DDHub hub:message view:self.view];
                    }
                }];
            } vc:self];
        }
    }];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _order ? 4 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_isNeedPlan && _expandPlan) {
            return 2 + _planModels.count;
        }
        return 2;
    };
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DDOrderStatusCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderStatusCellId"];
            cell.detailObj = _order;
//            cell.planModel = _currentPlan;
            [cell refreshWithModel:_currentPlan withType:self.type];
            cell.clipsToBounds = YES;
            @weakify(self)
            cell.explandBlock = ^{
                @strongify(self)
                self->_expandPlan = !self->_expandPlan;
                [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
            };
            cell.comfirmBlock = ^{
               @strongify(self)
                [self comfirmStep];
            };
            return cell;
        }else if (_isNeedPlan && indexPath.row <= _planModels.count && _expandPlan){
            DDOrderImplementationStepCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderImplementationStepCellId"];
//            cell.planModel = _planModels[indexPath.row - 1];
            [cell refreshWithModel:_planModels[indexPath.row - 1] withType:self.type];
            @weakify(self)
            cell.comfirmBlock = ^{
                @strongify(self)
                [self comfirmStep];
            };
            cell.coverImageDidClick = ^(NSString * _Nonnull url,
                                        UIButton * _Nonnull fromViewtop) {
                @strongify(self)
                if (!self) return ;
                NSMutableArray *items = [NSMutableArray new];
                YYPhotoGroupItem *groupItem = [YYPhotoGroupItem new];
                groupItem.thumbView = fromViewtop;
                groupItem.largeImageURL = [NSURL URLWithString:url];
                
                [items addObject:groupItem];
                YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
                [v presentFromImageView:fromViewtop toContainer:self.navigationController.view animated:YES completion:nil];
            };
            return cell;
        } else {
            DDOrderNumberCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderNumberCellId"];
            cell.detailObj = _order;
            return cell;
        }
    }else if (indexPath.section == 1) {
        DDOrderProductDataInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderProductDataInfoCellId"];
        cell.detailObj = _order;
        return cell;
    }else if (indexPath.section == 2) {
        DDOrderEffectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderEffectCellId"];
        cell.detailObj = _order;
        cell.clipsToBounds = YES;
        return cell;
    }else {
        DDOrderCompanyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderCompanyCellId"];
        cell.detailObj = _order;
        return cell;
    }
}


- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DDOrderHeaderView * headerView = [[[NSBundle mainBundle] loadNibNamed:@"DDOrderHeaderView" owner:nil options:nil] lastObject];
    if (section == 0) {
        headerView.orderTextLb.text = @"订单信息";
    }else if (section == 1) {
        headerView.orderTextLb.text = @"产品信息";
    }else if (section == 2) {
        headerView.orderTextLb.text = @"实施方信息";
    }else if (section == 2) {
        headerView.orderTextLb.text = @"企业信息";
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 2) {
//        if (_order.orderStatusType == DDOrderStatusCancel ||
//            _order.orderStatusType == DDOrderStatusPaySuccess ||
//            _order.orderStatusType == DDOrderStatusPay ||
//            _order.orderStatusType == DDOrderStatusLeaflets ||
//            _order.orderStatusType == DDOrderStatusOrderTaking ||
//            _order.orderStatusType == DDOrderStatusWaitPay) {
//            if (_order.isCompanyFirst && _order.orderStatusType == DDOrderStatusWaitPay) return 200;
//            return 0.0;
//        }
//    }
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            if (_expandPlan) {
                return 130;
            }
            return _isNeedPlan ?  185 : 100;
        }
        if (_isNeedPlan && indexPath.row <= _planModels.count && _expandPlan) {
            DDOrderPlanModel * planModel = _planModels[indexPath.row - 1];
            return planModel.cellHeight;
        }
        if ((_order.orderStatusType == DDOrderStatusOrderTaking ||
             _order.orderStatusType == DDOrderStatusLeaflets ||
             _order.orderStatusType == DDOrderStatusPaySuccess) &&
            [DDUserManager share].user.userType != DDUserTypePromoter ) {
            return 350;
        }
        if (_order.dispatchDate == 0) {
            return 280;
        }

        return 317;
    }
    if (indexPath.section == 1) {
        return 315;
    }

    if (indexPath.section == 2) {
//        if (_order.orderStatusType == DDOrderStatusCancel ||
//            _order.orderStatusType == DDOrderStatusPaySuccess ||
//            _order.orderStatusType == DDOrderStatusPay ||
//            _order.orderStatusType == DDOrderStatusLeaflets ||
//            _order.orderStatusType == DDOrderStatusOrderTaking ||
//            _order.orderStatusType == DDOrderStatusWaitPay) {
//            if (_order.isCompanyFirst && _order.orderStatusType == DDOrderStatusWaitPay) return 200;
//            return 0.0;
//        }
        return 200;
    }
    if (indexPath.section == 3) {
        return 170;
    }
    return 0;
}

@end
