//
//  DDReceiptVC.m
//  FYDD
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDReceiptVC.h"
#import "DDReceiptTypeCell.h"
#import "DDHeaderCell.h"
#import "DDInputContentCell.h"
#import "DDCommitCell.h"
#import "DDPostageCell.h"
#import "BRAddressPickerView.h"
#import "TYAlertController.h"
#import "DDPayTypeView.h"
#import "UIView+TYAlertView.h"
#import "DDAlertView.h"
#import "DDGetMoneyPasswordView.h"
#import "DDPayPasswordVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WechatOpenSDK/WXApi.h>
#import "DDPaySuccessVC.h"

@interface DDReceiptVC ()<UITableViewDelegate,UITableViewDataSource> {
    NSString *   _amount;   // 开票金额
    NSString *   _socialCreditCode; // 开票税号
    NSString *  _invoiceContent;   // 开票内容
    NSInteger _invoiceDay;      // 发票预计到达天数
    NSString * _enterpriseName; // 发票抬头
    double _expressAmount; // 发票快递费
    NSString * _expressPromptInfo;
    
    BOOL _isEmailReceipt;
    NSInteger _isPay;
    NSString * _receiveUser; // 收件人
    NSString * _receivePhone; // 收件人电话
    BRProvinceModel *_province;
    BRCityModel *_city;
    BRAreaModel *_area;
    NSString * _detailAdress;
    NSString * _expressId;
    
    NSInteger _isSend;
    BOOL _isCommitData;
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) DDPayTypeView * payTypeView;
@property (nonatomic,strong) DDGetMoneyPasswordView * payPasswordView;
@property (nonatomic,strong ) TYAlertController * alertController;
@end

@implementation DDReceiptVC
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"开具发票";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    _isEmailReceipt = NO;
    [self getReceiptData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlipayNote:) name:AlipayNotifyCationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechartNote:) name:WechatNotifyCationKey object:nil];
    _isCommitData = NO;
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDReceiptTypeCell" bundle:nil] forCellReuseIdentifier:@"DDReceiptTypeCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDClerkOrderCell" bundle:nil] forCellReuseIdentifier:@"DDClerkOrderCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDHeaderCell" bundle:nil] forCellReuseIdentifier:@"DDHeaderCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDInputContentCell" bundle:nil] forCellReuseIdentifier:@"DDInputContentCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDCommitCell" bundle:nil] forCellReuseIdentifier:@"DDCommitCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDPostageCell" bundle:nil] forCellReuseIdentifier:@"DDPostageCellId"];
    }
    return _tableView;
}

-(DDPayTypeView *)payTypeView{
    if (!_payTypeView) {
        _payTypeView = [DDPayTypeView createViewFromNib];
        
        if (iPhoneXAfter) {
            _payTypeView.height = 240;
        }
        @weakify(self)
        _payTypeView.payType = DDAppPayTypeAlipay |  DDAppPayTypeWallet | DDAppPayTypeWechat;
        _payTypeView.event = ^(DDAppPayType index) {
            @strongify(self)
            [self.alertController dismissViewControllerAnimated:YES];
            switch (index) {
                case DDAppPayTypeWallet:
                    [self getWalletPay];
                    break;
                case DDAppPayTypeWechat:
                    [self wechatPay];
                    break;
                case DDAppPayTypeBank:{

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

// 获取开发票内容
- (void)getReceiptData{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/tss/order/invoice/invoiceEdit?token=%@&orderNum=%@",[DDUserManager share].user.token,_orderNum]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           NSDictionary * dic = (NSDictionary *)data;
                           self->_enterpriseName = [dic valueForKeyPath:@"enterprise.enterpriseName"];
                           self->_socialCreditCode = [dic valueForKeyPath:@"enterprise.socialCreditCode"];
                           self->_invoiceContent = [dic valueForKeyPath:@"invoiceConfig.invoiceContents"];
                           self->_expressAmount = [[dic valueForKeyPath:@"invoiceConfig.expressAmount"] doubleValue];
                           self->_expressPromptInfo = [dic valueForKeyPath:@"invoiceConfig.expressPromptInfo"];
                           self->_amount = [dic valueForKeyPath:@"amount"];
                           self->_isSend = [[dic valueForKeyPath:@"invoiceConfig.isSend"] integerValue];
                           
                           [self.tableView reloadData];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  14 ;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.row == 0) {
        DDReceiptTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDReceiptTypeCellId"];
        cell.event = ^(NSInteger index) {
            @strongify(self)
            self->_isEmailReceipt = index == 0;
            [self.tableView reloadData];
        };
        cell.clipsToBounds = YES;
        return cell;
    }else if (indexPath.row == 1 || indexPath.row == 6 || indexPath.row == 11) {
        DDHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDHeaderCellId"];
        if (indexPath.row == 1) {
            cell.nameLb.text = @"发票详情";
        }else if (indexPath.row == 6) {
            cell.nameLb.text = @"接收方式";
        }else {
            cell.nameLb.text = @"温馨提示";
        }
        
        return cell;
    }else if ((_isEmailReceipt &(indexPath.row < 8)) || ((indexPath.row < 11)&& (!_isEmailReceipt))){
        DDInputContentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDInputContentCellId"];
        NSArray * titles = @[@"发票抬头",@"税号",@"发票内容",@"发票金额",@"收件人",@"联系电话",@"所在地区",@"详细地址"];
        NSString *adressna = @"";
        if (_province) {
            adressna = [NSString stringWithFormat:@"%@%@%@",_province.name,_city.name,_area.name];
        }
        NSArray * contents = @[yyTrimNullText(_enterpriseName),
                               yyTrimNullText(_socialCreditCode),
                               yyTrimNullText(_invoiceContent),
                               yyTrimNullText(_amount),
                               yyTrimNullText(_receiveUser),
                               yyTrimNullText(_receivePhone),
                               adressna,
                               yyTrimNullText(_detailAdress)];
        cell.contentLb.userInteractionEnabled = NO;
        NSString * name = @"";
        NSString * place = @"";
        NSString * content = @"";
        if (indexPath.row > 6 && indexPath.row < 11) {
            cell.contentLb.userInteractionEnabled = !_isCommitData;
        }
        // 电子发票
        if (_isEmailReceipt) {
            if (indexPath.row == 7) {
                name = @"电子邮箱";
                content = @"124512@qq.com";
            }else {
                name = titles[indexPath.row - 2];
                content = contents[indexPath.row - 2];
            }
        }else {
            if (indexPath.row < 7) {
                name = titles[indexPath.row - 2];
                content = contents[indexPath.row - 2];
            }else {
                name = titles[indexPath.row - 3];
                content = contents[indexPath.row - 3];
                if (indexPath.row != 9) {
                    cell.contentLb.userInteractionEnabled = YES;
                    place = [NSString stringWithFormat:@"请填写%@",name];
                }else {
                    place = @"请选择区域";
                }
            }
        }
        cell.contentLb.keyboardType = UIKeyboardTypeDefault;
        if (indexPath.row == 8 ){
            cell.contentLb.keyboardType = UIKeyboardTypePhonePad;
        }else if (indexPath.row == 9 ) {
            cell.contentLb.userInteractionEnabled = NO;
        }
        cell.contentLb.placeholder = place;
        cell.contentLb.text = content;
        cell.nameLb.text = name;
        cell.indexPath = indexPath;
        
        cell.textChange = ^(NSString *text, NSIndexPath *index_path) {
            if (index_path.row == 7){
                self->_receiveUser = text;
            }else if (index_path.row == 8) {
                self->_receivePhone = text;
            }else if (index_path.row == 10) {
                self->_detailAdress = text;
            }
        };
        return cell;
    }else if ( indexPath.row == 12) {
        DDPostageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDPostageCellId"];
        cell.nameLb.text = yyTrimNullText(_expressPromptInfo);
        return cell;
    } else {
        DDCommitCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCommitCellId"];
        cell.event = ^{
            @strongify(self)
            [self pay];
        };
        return cell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return 0.01;
    if (indexPath.row < 12) return 44;
    if ( indexPath.row == 12) return 50;
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 9 && !_isCommitData){
        @weakify(self)
        [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeArea
                                           defaultSelected:@[]
                                              isAutoSelect:YES
                                                themeColor:nil
                                               resultBlock:^(BRProvinceModel *province,
                                                             BRCityModel *city,
                                                             BRAreaModel *area) {
                                                   @strongify(self)
                                                   if (!self) return;
                                                   self->_province = province;
                                                   self->_city = city;
                                                   self->_area = area;
                                                   [self.tableView reloadData];
                                               } cancelBlock:^{
                                                   
                                               }];
    }
}



// 支付
- (void)pay{
    if (self->_isCommitData) {
         [self showPayView];
        return;
    }
    
    // 保存发票信息
    if (_receiveUser.length == 0) {
        [DDHub hub:@"请输入收件人" view:self.view];
        return;
    }
    if (_receivePhone.length == 0) {
        [DDHub hub:@"请输入电话" view:self.view];
        return;
    }
    if (!_area) {
        [DDHub hub:@"请选择地址" view:self.view];
        return;
    }
    if (_detailAdress.length == 0) {
        [DDHub hub:@"请输入详细地址" view:self.view];
        return;
    }
    [DDHub hub:self.view];
    NSString * body = [NSString stringWithFormat:@"{\"orderNumber\" : \"%@\",\"addressee\" : \"%@\",\"addresseePhone\" : \"%@\",\"addressessArea\" : \"%@\",\"addressessAddress\" : \"%@\",\"userEmail\" : 1}",_orderNum,_receiveUser,_receiveUser,_area.code,_detailAdress];
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/tss/order/invoice/saveInvoiceDetail?token=", [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           self->_expressId = [NSString stringWithFormat:@"%@",data[@"id"]];
                           self->_isCommitData = YES;
                           // 免邮
                           if (self->_isSend == 1) {
                               [self.navigationController popViewControllerAnimated:YES];
                           }else {
                           // 支付
                                self->_isPay = [yyTrimNullText(data[@"isPay"]) integerValue];
                               if (self->_isPay != 2) {
                                   [self showPayView];
                               }else {
                                   [self.navigationController popViewControllerAnimated:YES];
                               }
                           }
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

- (void)showPayView{
    if (!_alertController){
        _alertController = [TYAlertController alertControllerWithAlertView:self.payTypeView preferredStyle:TYAlertControllerStyleActionSheet];
        _alertController.backgoundTapDismissEnable = YES;
    }
    [self presentViewController:_alertController animated:YES completion:nil];
}
#pragma mark - 钱包支付
- (void)getWalletPay{
    @weakify(self)
    [DDHub hub:self.view];
    [[DDUserManager share] getUserPayPasswordStateCompletion:^(BOOL suc) {
        @strongify(self)
        if (!self) return ;
        [DDHub dismiss:self.view];
        // 判断是否这是支付密码
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
            [self showPayPassword];
        }
    }];
    
}

// 钱包支付输入密码
- (void)showPayPassword{
    _payPasswordView = [DDGetMoneyPasswordView createViewFromNib];
    if (iPhoneXAfter) {
        _payPasswordView.height = 220;
    }
    _payPasswordView.title = @"支付快递费";
    _payPasswordView.money = _expressAmount;
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
    NSString * body = [NSString stringWithFormat:@"{\"id\" : \"%@\" , \"payType\" :\"1\" , \"payPassword\" : \"%@\" }",_expressId,password];
    [DDHub hub:self.view];
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/tss/invoicepay/payment?token=", [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           DDPaySuccessVC * vc = [DDPaySuccessVC new];
                           vc.orderId = self.orderNum;
                           vc.isReceiptVCPay = YES;
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
                         // req.openID = [DDUserManager share].user.wechatOpenid;
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
    NSString * body = [NSString stringWithFormat:@"{\"id\" : \"%@\" , \"payType\" : %zd }",_expressId,type];
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/tss/invoicepay/payment?token=",
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
//        [DDHub hub:@"充值成功" view:self.view];
        DDPaySuccessVC * vc = [DDPaySuccessVC new];
        vc.orderId = _orderNum;
        vc.isReceiptVCPay = YES;
        [DDAppManager gotoVC:vc navigtor:self.navigationController];
    }else if (status == 8000) {
        [DDHub hub:@"支付中" view:self.view];
    }else if (status == 6001) {
        [DDHub hub:@"取消了支付" view:self.view];
    }else {
        [DDHub hub:@"支付失败" view:self.view];
    }
}

- (void)wechartNote:(NSNotification *)note{
    NSInteger status = [note.object integerValue];
    switch (status) {
        case 0:{
//            [DDHub hub:@"支付成功" view:self.view];
            DDPaySuccessVC * vc = [DDPaySuccessVC new];
            vc.orderId = _orderNum;
            vc.isReceiptVCPay = YES;
            [DDAppManager gotoVC:vc navigtor:self.navigationController];
        } break;
        case -1:
            [DDHub hub:@"支付中" view:self.view];
            break;
        case -2:
            [DDHub hub:@"取消了支付" view:self.view];
            break;
        default:
            [DDHub hub:@"支付失败" view:self.view];
            break;
    }
}



@end
