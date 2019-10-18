//
//  DDTransferVC.m
//  FYDD
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDTransferVC.h"
#import "DDOrderTranferCell.h"
#import "DDOrderPayInfoCell.h"
#import "DDPaySuccessVC.h"
#import "DDOrderPayTopInfoCell.h"
#import "DDCommitCell.h"
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>
#import <UIImage+YYAdd.h>
#import "DDOrderDetailInfo.h"
#import <UITableView+YYAdd.h>
#import "DDAlertView.h"

@interface DDTransferVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString * _code;
    NSString * _url;
    DDOrderDetailInfo * _orderInfo;
    NSString * _bankCardNum;
    NSString * _companyName;
    NSString * _openBank;
    NSString * _telephone;
    
}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDTransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"线下转账";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    [self getOrderInfoData];
    [self getBankInfo];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
}

// 获取用户信息
- (void)getOrderInfoData{
    if (_orderNumber.length == 0) {
        return;
    }
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/tss/orders/getOrderInfo?orderNumber=%@&token=%@",_orderNumber,[DDUserManager share].user.token]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       [DDHub dismiss:self.view];
                       if (code == 200) {
                           self->_orderInfo = [DDOrderDetailInfo modelWithJSON:data];
                           [self.tableView reloadData];
                       }
                   }];
}

// 获取用户信息
- (void)getBankInfo{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:@"/fps/bank/card/getCompanyBankInfoConfig"
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSDictionary * data) {
                       @strongify(self)
                       if (!self) return ;
                       [DDHub dismiss:self.view];
                       if (code == 200) {
                           self->_bankCardNum = [self dealWithString: data[@"bankCardNum"]];
                           self->_companyName = data[@"companyName"];
                           self->_openBank =   data[@"openBank"] ;
                            self->_telephone = yyTrimNullText(data[@"telephone"]);
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
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDOrderPayInfoCell" bundle:nil] forCellReuseIdentifier:@"DDOrderPayInfoCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDOrderTranferCell" bundle:nil] forCellReuseIdentifier:@"DDOrderTranferCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDOrderPayTopInfoCell" bundle:nil] forCellReuseIdentifier:@"DDOrderPayTopInfoCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDCommitCell" bundle:nil] forCellReuseIdentifier:@"DDCommitCellId"];
    }
    return _tableView;
}



#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.row == 0) {
        if (_money.length > 0) {
            DDOrderPayTopInfoCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderPayTopInfoCellId"];
            cell.moneyLb.text = _money;
            return cell;
        }else {
            DDOrderPayInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderPayInfoCellId"];
            cell.nameLb.text = _orderInfo.orders.productName;
            if (yyTrimNullText(_orderInfo.orders.implementationPhone).length > 0){
                cell.nameLb2.text = [NSString stringWithFormat:@"%@ %@",_orderInfo.orders.implementationName,_orderInfo.orders.implementationPhone];
            }else {
                cell.nameLb2.text = [NSString stringWithFormat:@"上线实施-%@",_orderInfo.onlineMemberName];
            }
            cell.orderNumber.text = [NSString stringWithFormat:@"订单号: %@",_orderNumber];
            [cell setTotalPrice:_orderInfo.orders.paymentAmount];
            [cell setProductCost:_orderInfo.orders.implementationCost];
            [cell setProductPrice:_orderInfo.orders.productAmount];
            if (_orderInfo.orders.isRenew) {
                cell.nameLb2.hidden = YES;
                cell.priceLb2.hidden = YES;
            }
            return cell;
        }

    }else if (indexPath.row == 1){
        DDOrderTranferCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"DDOrderTranferCellId"];
        [cell setImageURL:_url];
        cell.companyNameLb.text = yyTrimNullText(_companyName);
        cell.companyNoLb.text = yyTrimNullText(_bankCardNum);
        cell.companyBankLb.text = yyTrimNullText(_openBank);
        [cell.phoneBtn setTitle:yyTrimNullText(_telephone) forState:UIControlStateNormal];
        @weakify(self)
        cell.phoneCallButtonDidClick = ^{
            @strongify(self)
            [DDAlertView showTitle:@"提示"
                          subTitle:[NSString stringWithFormat:@"是否拨打%@",self->_telephone]
                         sureEvent:^{
                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self->_telephone]]];
                         } cancelEvent:^{
                             
                         }];
        };
        cell.block = ^(NSInteger index) {
            @strongify(self)
            if (!self) return ;
            [self camara];
        };
        cell.liushuimaLb.text = _code;
        cell.textBlock = ^(NSString *text) {
            @strongify(self)
            if (!self) return ;
            self->_code = text;
        };
        return cell;
    }else {
        DDCommitCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCommitCellId"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell.commitBtn setTitle:@"支付" forState:UIControlStateNormal];
        cell.event = ^{
            @strongify(self)
            if (!self) return ;
            [self pay];
        };
        return cell;
    }
    return nil;
}

- (NSString *)dealWithString:(NSString *)number
{
    NSString *doneTitle = @"";
    int count = 0;
    for (int i = 0; i < number.length; i++) {
        
        count++;
        doneTitle = [doneTitle stringByAppendingString:[number substringWithRange:NSMakeRange(i, 1)]];
        if (count == 6) {
            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
            count = 0;
        }
    }
    return doneTitle;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        if (_money.length > 0) {
            return 100;
        }
        return _orderInfo.orders.isRenew ? 160 : 230;
    }
    if (indexPath.row == 1) return 420;
    if (indexPath.row == 2) return 80;
    return 30;
}

- (void)pay{
 
    if(_code.length == 0) {
        [DDHub hub:@"请输入流水码" view:self.view];
        return;
    }
    if(_url.length == 0) {
        [DDHub hub:@"请输入充值截图" view:self.view];
        return;
    }
    NSString * body = @"";
    NSString * url = @"";
    if (_money.length > 0) {
        body = [NSString stringWithFormat:@"{\"amountMoney\" : \"%@\",\"offlineRechargeInfo\" :\"%@,%@\",\"payType\" : 4}",_money,_code,_url];
        url = YYFormat(@"/fps/wallet/payment/torecharge?token=", [DDUserManager share].user.token);
    }else {
        body = [NSString stringWithFormat:@"{\"orderNumber\" : \"%@\",\"offlineRechargeInfo\" :\"%@;%@\",\"payType\" : 4}",_orderNumber,_code,_url];
        url = YYFormat(@"/tss/orderpay/orderPayment?token=", [DDUserManager share].user.token);
    }
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:url
                         body:body
                   completion:^(NSInteger code, NSString *message,id data) {
                       @strongify(self)
                       if(!self) return ;
                       if (code == 200 || code == 2001) {
                           DDPaySuccessVC * vc = [DDPaySuccessVC new];
                           vc.isWalletPay = NO;
                           vc.orderId = self.orderNumber;
                           vc.isBank = self.isChongZhi;
                           vc.isOrderChong = self.isOrderChong;
                           [DDAppManager gotoVC:vc navigtor:self.navigationController];
                       }else {

                           [DDHub hub:message view:self.view];
                       }
                   }];
}

- (void)camara{
    [self.view endEditing:YES];
    @weakify(self)
    [self showPhotoActionSheetCompletion:^(bool suc, NSString *url) {
        @strongify(self)
        if (!self) return ;
        if (suc) {
            self->_url = url;
            [self.tableView reloadData];
        }else {
            [DDHub hub:@"上传图片失败" view:self.view];
        }
    }];
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
