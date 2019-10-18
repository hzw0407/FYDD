//
//  DDClerkOrderVC.m
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "OrderDetailVC.h"
#import "DDClerkInfoCell.h"
#import "DDClerkProductCell.h"
#import "DDClerkTimeCell.h"
#import "DDClerkActualizeCell.h"
#import "DDReceiptVC.h"
#import "BRDatePickerView.h"
#import "DDAlertView.h"
#import "DDAlertView.h"
#import "DDPayPasswordVC.h"
#import "DDAlertInputView.h"
#import "DDGetMoneyPasswordView.h"
#import "UIView+TYAlertView.h"
#import "DDPayTypeView.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WechatOpenSDK/WXApi.h>
#import "DDOrderDetailInfo.h"
#import "DDTransferVC.h"
#import "DDPaySuccessVC.h"
#import <FSCalendar/FSCalendar.h>
#import "DDOrderReceptDetailVC.h"
#import "DDCommentVC.h"
#import "DDOrderContactListCell.h"
#import "DDOrderRenewCell.h"
#import "DDOrderDownCell.h"
#import "DDWebVC.h"

@interface OrderDetailVC ()<UITableViewDelegate,UITableViewDataSource> {
    DDOrderDetailInfo * _orderInfo;
    NSString * _member;
}
@property (nonatomic,strong) IBOutlet UITableView * tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton2;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLbLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button1WidthCons;

// 支付相关控件
@property (nonatomic,strong) DDGetMoneyPasswordView * payPasswordView;
@property (nonatomic,strong) DDPayTypeView * payTypeView;
@property (nonatomic,strong ) TYAlertController * alertController;
@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getOrderInfoData];
}

- (void)updateUI{
    NSMutableAttributedString *priceAtt = [NSMutableAttributedString new];
    NSMutableAttributedString *attribut1 = [[NSMutableAttributedString alloc]initWithString:@"费用总额 "];
    [attribut1 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                               NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0,4)];
    NSString * text2 = [NSString stringWithFormat:@"¥%.2f",_orderInfo.orders.paymentAmount];
    NSMutableAttributedString *attribut2 = [[NSMutableAttributedString alloc]initWithString:text2];
    [attribut2 addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                               NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0,text2.length)];
    [priceAtt appendAttributedString:attribut1];
    [priceAtt appendAttributedString:attribut2];
    _priceLb.textAlignment = NSTextAlignmentCenter;
    _priceLb.attributedText = priceAtt;
    
    NSString * orderStatus = _orderInfo.orders.orderStatus;
    _bottomButton1.hidden = YES;
    _bottomButton2.hidden = YES;
    _priceLbLeftCons.constant = 25;
    
    switch ([DDUserManager share].user.userType) {
        case DDUserTypeOnline:{
            // 未接单
            if (//[orderStatus isEqualToString:@"030"] ||
                //[orderStatus isEqualToString:@"020"] ||
                [orderStatus isEqualToString:@"031"]) {
                [_bottomButton1 setTitle:@"接单" forState:UIControlStateNormal];
                [_bottomButton2 setTitle:@"拒接" forState:UIControlStateNormal];
                _bottomButton1.tag = 10004;
                _bottomButton2.tag = 10005;
                _bottomButton1.hidden = NO;
                _bottomButton2.hidden = NO;
                _priceLb.textAlignment = NSTextAlignmentLeft;
                _priceLbLeftCons.constant = 200;
            }else if([orderStatus isEqualToString:@"050"] ||
                   [orderStatus isEqualToString:@"040"]) {
                _button1WidthCons.constant = 120;
                _bottomButton1.hidden = NO;
                [_bottomButton1 setTitle:@"完成" forState:UIControlStateNormal];
                _bottomButton1.tag = 10009;
                _priceLb.textAlignment = NSTextAlignmentLeft;
                _priceLbLeftCons.constant = 140;
            }
        }break;
        case DDUserTypeSystem:
            // 支付失败
            if ([orderStatus isEqualToString:@"022"] ||
                [orderStatus isEqualToString:@"010"] ) {
                _button1WidthCons.constant = 120;
                _bottomButton1.hidden = NO;
                [_bottomButton1 setTitle:_orderInfo.orders.isRenew ? @"续费" : @"支付" forState:UIControlStateNormal];
                _bottomButton1.tag = 10001;
                _priceLb.textAlignment = NSTextAlignmentLeft;
                _priceLbLeftCons.constant = 140;
            // 开票
            }else if ([orderStatus isEqualToString:@"070"] && _orderInfo.orders.isInvoice){
                _button1WidthCons.constant = 120;
                _bottomButton1.hidden = NO;
                [_bottomButton1 setTitle:@"查看发票" forState:UIControlStateNormal];
                _bottomButton1.tag = 10007;
                _priceLb.textAlignment = NSTextAlignmentLeft;
                _priceLbLeftCons.constant = 140;
            }else if ([orderStatus isEqualToString:@"070"] &&
                      _orderInfo.isShowInvoiceBtn == 1 &&
                      !_orderInfo.orders.isInvoice) {
                _button1WidthCons.constant = 120;
                _bottomButton1.hidden = NO;
                [_bottomButton1 setTitle:@"开具发票" forState:UIControlStateNormal];
                _bottomButton1.tag = 10002;
                _priceLb.textAlignment = NSTextAlignmentLeft;
                 _priceLbLeftCons.constant = 140;
            }else {
                 if ([orderStatus isEqualToString:@"060"]){
                    _button1WidthCons.constant = 120;
                    _bottomButton1.hidden = NO;
                    [_bottomButton1 setTitle:@"评价" forState:UIControlStateNormal];
                    _bottomButton1.tag = 10006;
                    _priceLb.textAlignment = NSTextAlignmentLeft;
                    _priceLbLeftCons.constant = 140;
                }
            }
            break;
            
        case DDUserTypePromoter:{
            
        }break;
            
        default:
            break;
    }
    [self.view layoutIfNeeded];
}

- (void)setupUI{
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = UIColorHex(0xEFEFF6);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"DDClerkInfoCell" bundle:nil] forCellReuseIdentifier:@"DDClerkInfoCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDClerkProductCell" bundle:nil] forCellReuseIdentifier:@"DDClerkProductCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDClerkTimeCell" bundle:nil] forCellReuseIdentifier:@"DDClerkTimeCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDClerkActualizeCell" bundle:nil] forCellReuseIdentifier:@"DDClerkActualizeCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDOrderContactListCell" bundle:nil] forCellReuseIdentifier:@"DDOrderContactListCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDOrderRenewCell" bundle:nil] forCellReuseIdentifier:@"DDOrderRenewCellId"];
    [_tableView registerNib:[UINib nibWithNibName:@"DDOrderDownCell" bundle:nil] forCellReuseIdentifier:@"DDOrderDownCellId"];
    // DDOrderDownCellId
    
    if (iPhoneXAfter) {
        _cons.constant =  30;
    }
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
                           
                           NSString * dateText = [self->_orderInfo.orders.dispatchDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                           dateText = [dateText stringByReplacingOccurrencesOfString:@".000+0000" withString:@""];
                           NSDateFormatter * formate1 = [[NSDateFormatter alloc] init];
                           formate1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                           
                           self->_orderInfo.date = [formate1 dateFromString:dateText];
                           
                           [self updateUI];
                           [self.tableView reloadData];
                       }
                   }];
}

- (void)takeOrders:(NSString *)date{
    [DDHub hub:self.view];
     NSString * body = [NSString stringWithFormat:@"{\"dateStr\" : \"%@\"  , \"orderNumber\" : \"%@\"}",date,_orderInfo.orders.orderNumber];
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/tss/orders/takeOrders?token=", [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           [self getOrderInfoData];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

- (void)trefuseOrder{
    [DDHub hub:self.view];
    NSString * body = [NSString stringWithFormat:@"{\"orderNumber\" : \"%@\"}",_orderInfo.orders.orderNumber];
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

#pragma mark - bottomBarEvent
- (IBAction)buttonEventClick:(UIButton *)sender {
    switch (sender.tag) {
            // 支付
        case 10001:
            [self gotoPay];
            break;
            // 开票
        case 10002:{
            DDReceiptVC * vc = [DDReceiptVC new];
            vc.orderNum = _orderId;
            [self.navigationController pushViewController:vc animated:YES];
        }break;
            // 续费
        case 10003:{
            [self gotoPay];
        }break;
            // 接单
        case 10004:{
            NSString * beginDate =  [self getDateFormat:_orderInfo.orders.dispatchDate];
            NSDateFormatter * formate1 = [[NSDateFormatter alloc] init];
            formate1.dateFormat = @"yyyy-MM-dd";
            NSDate * date = [formate1 dateFromString:beginDate];
            @weakify(self)
            [BRDatePickerView showDatePickerWithTitle:@"选择服务开始时间"
                                           dateType:BRDatePickerModeYMD
                                      defaultSelValue:@""
                                              minDate:[NSDate date] maxDate:nil
                                         isAutoSelect:NO
                                           themeColor:nil resultBlock:^(NSString *selectValue) {
                                               
                                               @strongify(self)
                                               [self takeOrders:selectValue];
                                           }];

        }break;
            // 拒接
        case 10005:{
            [DDAlertView showTitle:@"提示"
                          subTitle:@"您确定拒绝该订单?"
                         sureEvent:^{
                             [self trefuseOrder];
                         } cancelEvent:^{
                             
                         }];
            // 评价
        }break;
        case 10006:{
            DDCommentVC * vc = [DDCommentVC new];
            vc.orderNumber = _orderId;
            vc.name = _orderInfo.orders.extensionName;
            vc.name1 = _orderInfo.orders.implementationName;
            vc.orderId = _orderInfo.orders.orderId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            // 查看发票
        case 10007:{
            DDOrderReceptDetailVC * vc = [DDOrderReceptDetailVC new];
            vc.orderNum = _orderId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10009:{
            @weakify(self)
            [DDAlertView showTitle:@"提示"
                          subTitle:@"确定已完成订单?"
                         sureEvent:^{
                             @strongify(self)
                             [self confirmOrderBtn];
                         } cancelEvent:^{
                             
                         }];
        }break;
            
        default:
            break;
    }

}

- (void)confirmOrderBtn{
    [DDHub hub:self.view];
    NSString * body = [NSString stringWithFormat:@"{\"orderNumber\" : \"%@\"}",_orderInfo.orders.orderNumber];
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/tss/orders/setOrdersStatusOfEvaluate?token=", [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub hub:@"提交成功" view:self.view];
                           [self getOrderInfoData];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

#pragma mark - UI
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
                    vc.orderNumber = self->_orderId;
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

- (NSInteger)getCount{
    return 6;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  6;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (_orderInfo.orders.isRenew) {
            DDOrderRenewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderRenewCellId"];
            cell.info = _orderInfo;
            return cell;
        }else {
            DDClerkInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDClerkInfoCellId"];
            cell.info = _orderInfo;
            cell.clipsToBounds = YES;
            return cell;
        }
    }else if (indexPath.row == 1) {
        DDClerkTimeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDClerkTimeCellId"];
        cell.date = self->_orderInfo.date;
        cell.clipsToBounds = YES;
        return cell;
    }else if (indexPath.row == 2){
        DDClerkProductCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDClerkProductCellId"];
        cell.info = _orderInfo;
        return cell;
    }else if (indexPath.row == 3) {
        DDClerkActualizeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDClerkActualizeCellId"];
        cell.info = _orderInfo;
        cell.clipsToBounds = YES;
        return cell;
    }else if (indexPath.row == 4){
        DDOrderContactListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderContactListCellId"];
        cell.contactNameLb.text = [NSString stringWithFormat:@"实施联系人: %@",yyTrimNullText(_orderInfo.orders.userLinkman)];
        cell.clipsToBounds = YES;
        [cell.phoneBtn setTitle:yyTrimNullText(_orderInfo.orders.userLinkmanPhone) forState:UIControlStateNormal];
        @weakify(self)
        cell.event = ^{
            @strongify(self)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",yyTrimNullText(self->_orderInfo.orders.userLinkman)]]];
        };
        return cell;
    }else {
        DDOrderDownCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderDownCellId"];
        cell.clipsToBounds = YES;
        @weakify(self)
        cell.event = ^(NSInteger index) {
            @strongify(self)
            if (index == 1 || index == 3) {
                if (index == 1) {
                    if (!self->_orderInfo.orders.applyno ||
                        self->_orderInfo.orders.applyno.length == 0) {
                        [DDHub hub:@"该订单暂无合同!" view:self.view];
                        return ;
                    }
                }else {
                    if (!self->_orderInfo.orders.apply2no ||
                        self->_orderInfo.orders.apply2no.length == 0) {
                        [DDHub hub:@"该订单暂无合同!" view:self.view];
                        return ;
                    }
                }
                DDWebVC * vc = [DDWebVC new];
                vc.title = @"合同详情";
                vc.url = index == 1 ? self->_orderInfo.orders.applyno : self->_orderInfo.orders.apply2no;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                
            }
        };
        return  cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        if (_orderInfo.orders.isRenew)  {
            return 170;
        }
        if ([_orderInfo.orders.orderStatus isEqualToString:@"030"] ||
            [_orderInfo.orders.orderStatus isEqualToString:@"020"] ||
            [_orderInfo.orders.orderStatus isEqualToString:@"031"]){
            return 200;
        }else if ([_orderInfo.orders.orderStatus isEqualToString:@"000"] ||
                  [_orderInfo.orders.orderStatus isEqualToString:@"010"] ||
                  [_orderInfo.orders.orderStatus isEqualToString:@"022"] ||
                  [_orderInfo.orders.orderStatus isEqualToString:@"021"]){
            return 166;
        }
        return 240;
    }
    
    if (indexPath.row == 5) {
        if ([_orderInfo.orders.orderStatus isEqualToString:@"000"] ||
            [_orderInfo.orders.orderStatus isEqualToString:@"010"] ||
            [DDUserManager share].user.userType != DDUserTypeSystem){
            return 0.01;
        }
        return 160;
    }
    if (indexPath.row == 1){
        if ([DDUserManager share].user.userType != DDUserTypePromoter){
            NSString * orderStatus = _orderInfo.orders.orderStatus;
            if ([orderStatus isEqualToString:@"031"]) {
                return 38;
            }
        }
        return 0.01;
    }
    if (indexPath.row == 2) {
        NSString * textCount = yyTrimNullText(_orderInfo.orders.extensionName);
        return textCount.length > 0 ? 150 : 90;
        
    }
    if (indexPath.row == 3) {
        if (_orderInfo.orders.isRenew) {
            return 0.01;
        }
    }
    if (indexPath.row == 4) {
        if ([DDUserManager share].user.userType == DDUserTypeOnline) {
            if ([_orderInfo.orders.orderStatus isEqualToString:@"050"] ||
                [_orderInfo.orders.orderStatus isEqualToString:@"060"] ||
                [_orderInfo.orders.orderStatus isEqualToString:@"070"] ||
                [_orderInfo.orders.orderStatus isEqualToString:@"040"]){
                return 110;
            }
        }
        return 0.01;
    }
    return 160;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row  > 0) {
        
    }
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
                                           [self getOrderInfoData];
                                           [self showPayPassword];
                                       }else {
                                           [DDHub hub:message view:self.view];
                                       }
                                   }];
                    
                } cancelEvent:^{
                    [self showPayPassword];
                }];
            }
            
        }
    }];
    
}

// 钱包支付输入密码
- (void)showPayPassword{
    _payPasswordView = [DDGetMoneyPasswordView createViewFromNib];
    if (iPhoneXAfter) {
        _payPasswordView.height = 220;
    }
    _payPasswordView.title = @"购买产品";
    _payPasswordView.money = _orderInfo.orders.paymentAmount;
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
                           vc.isWalletPay = YES;
                           vc.orderId = self->_orderInfo.orders.orderNumber;
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
        [self getOrderInfoData];
    }else if (status == 8000) {
        [DDHub hub:@"充值正在处理中" view:self.view];
    }else if (status == 6001) {
        [DDHub hub:@"您取消了充值" view:self.view];
    }else {
        [DDHub hub:@"充值失败" view:self.view];
    }
}

@end
