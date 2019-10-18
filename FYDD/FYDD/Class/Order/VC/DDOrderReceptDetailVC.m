//
//  DDOrderReceptDetailVC.m
//  FYDD
//
//  Created by mac on 2019/4/12.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDOrderReceptDetailVC.h"
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
#import "DDReceiptVC.h"

@interface DDOrderReceptDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *   _textValue1;   // 开票金额
    NSString *   _textValue2;
    NSString *   _textValue3;
    NSString *   _textValue4;
    NSString *   _textValue5;
    NSString *   _textValue6;
    NSString *   _textValue7;
    NSString *   _expressCompany;
    NSInteger _invoiceStatus;
    NSInteger _isPay;
    NSString * _expressId;
    double _expressAmount; // 发票快递费
    NSString * _invoicePic; // 发票图片
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) DDPayTypeView * payTypeView;
@property (nonatomic,strong) DDGetMoneyPasswordView * payPasswordView;
@property (nonatomic,strong ) TYAlertController * alertController;
@end

@implementation DDOrderReceptDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"查看发票";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlipayNote:) name:AlipayNotifyCationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechartNote:) name:WechatNotifyCationKey object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getReceiptData];
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


// 获取开发票内容
- (void)getReceiptData{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/tss/order/invoice/invoiceDetail?token=%@&orderNum=%@",[DDUserManager share].user.token,_orderNum]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           NSDictionary * dic = (NSDictionary *)data;
                           self->_textValue1 = dic[@"invoiceTitle"];
                           self->_textValue2 = dic[@"identificationNumber"];
                           self->_textValue3 = dic[@"invoiceContents"];
                           self->_textValue4 = [NSString stringWithFormat:@"%@元",dic[@"amount"]];
                           self->_textValue5 = [NSString stringWithFormat:@"%@",dic[@"invoiceCode"]];
                           self->_textValue6 = [NSString stringWithFormat:@"%@",dic[@"invoiceCode2"]];
                           self->_expressCompany = [NSString stringWithFormat:@"%@",dic[@"expressCompany"]];
                           self->_textValue7 = dic[@"expressNumber"];
                           self->_invoicePic = yyTrimNullText(dic[@"invoicePic"]);
                           self->_invoiceStatus = [yyTrimNullText(dic[@"invoiceStatus"]) integerValue];
                           self->_isPay = [yyTrimNullText(dic[@"isPay"]) integerValue];
                           self->_expressId = [NSString stringWithFormat:@"%@",data[@"id"]];
                           self->_expressAmount = [[NSString stringWithFormat:@"%@",data[@"expressAmount"]] doubleValue];
                           
                           [self.tableView reloadData];
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

- (void)showPayView{
    if (!_alertController){
        _alertController = [TYAlertController alertControllerWithAlertView:self.payTypeView preferredStyle:TYAlertControllerStyleActionSheet];
        _alertController.backgoundTapDismissEnable = YES;
    }
    [self presentViewController:_alertController animated:YES completion:nil];
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


- (void)downReceipt{
    
}

- (void)downLoadServiceRequest{
    if (!_invoicePic || ![_invoicePic hasPrefix:@"http"]) {
        [DDHub hub:@"暂未有发票扫描件" view:self.view];
        return;
    }
    [DDHub hub:self.view];
    @weakify(self)
    [[SDWebImageManager sharedManager].imageLoader requestImageWithURL:[NSURL URLWithString:_invoicePic] options:SDWebImageAvoidAutoSetImage
                                                               context:nil
                                                              progress:^(NSInteger receivedSize,
                                                                         NSInteger expectedSize,
                                                                         NSURL * _Nullable targetURL) {
                                                                  
                                                              } completed:^(UIImage * _Nullable image,
                                                                            NSData * _Nullable data,
                                                                            NSError * _Nullable error,
                                                                            BOOL finished) {
                                                                  @strongify(self)
                                                                  if (!self) return ;
                                                                  [DDHub dismiss:self.view];
                                                                  if (image) {
                                                                      UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                                                                      
                                                                  }
                                                              }];
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        [DDHub hub:@"保存相册失败" view:self.view];
    }else{
        [DDHub hub:@"已保存到相册" view:self.view];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  11 ;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        DDHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDHeaderCellId"];
        cell.nameLb.text = @"发票详情";
        return cell;
    }else if(indexPath.row == 10) {
        DDCommitCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCommitCellId"];
        if (_isPay != 2) {
            [cell.commitBtn setTitle:@"支付快递费" forState:UIControlStateNormal];
        }else {
            if (_invoiceStatus == 2) {
                [cell.commitBtn setTitle:@"下载发票扫描件" forState:UIControlStateNormal];
            }else if (_invoiceStatus == -1) {
                [cell.commitBtn setTitle:@"重新开票" forState:UIControlStateNormal];
            }
        }
        cell.clipsToBounds = YES;
        @weakify(self)
        cell.event = ^{
            @strongify(self)
            if (self->_isPay != 2) {
                [self showPayView];
            }else {
                if (self->_invoiceStatus == 2) {
                    [self downLoadServiceRequest];
                }else if (self->_invoiceStatus == -1) {
                    DDReceiptVC * vc = [DDReceiptVC new];
                    vc.orderNum = self.orderNum ;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        };
        return cell;
    }else {
        DDInputContentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDInputContentCellId"];
        NSArray * titles = @[@"开票状态",@"发票抬头",@"税号",@"发票内容",@"发票金额",@"发票号码",@"发票代码",@"快递公司",@"快递单号"];
        NSString * status = @"未支付";
        if (_isPay == 2) {
            if (_invoiceStatus == -1) {
                status = @"未通过";
            }else if (_invoiceStatus == 2){
                status = @"已开票";
            }else if (_invoiceStatus == 3){
                status = @"快递中";
            }else if (_invoiceStatus == 0){
                status = @"开票中";
            }
        }
        NSArray * contents = @[yyTrimNullText(status)
                               ,yyTrimNullText(_textValue1),
                               yyTrimNullText(_textValue2),
                               yyTrimNullText(_textValue3),
                               yyTrimNullText(_textValue4),
                               yyTrimNullText(_textValue5),
                               yyTrimNullText(_textValue6),
                               yyTrimNullText(_expressCompany),
                               yyTrimNullText(_textValue7),
                               
                               ];
        cell.contentLb.userInteractionEnabled = NO;
        if (indexPath.row  > 1) {
            cell.contentLb.text = contents[indexPath.row - 1];
            cell.nameLb.text = titles[indexPath.row - 1];
        }else {
            cell.contentLb.text = contents[indexPath.row];
            cell.nameLb.text = titles[indexPath.row];
        }
        if (indexPath.row == 0) {
            cell.contentLb.textColor = UIColorHex(0xF2934F);
        }else {
            cell.contentLb.textColor = UIColorHex(0x8C9FAD);
        }
        cell.indexPath = indexPath;
        return cell;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 10) {
        if (_isPay != 2 || _invoiceStatus == 2 || _invoiceStatus == -1) {
            return 80;
        }
        return 0.01;
    }
    
    return 44;
}


@end
