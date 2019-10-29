//
//  DDProductNextOrderVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/7.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProductNextOrderVc.h"
#import "BRAddressPickerView.h"
#import "DDProductAgreeServiceVc.h"
#import "DDOrderDetailVc.h"

@interface DDProductNextOrderVc () {
    NSString * _cityCode;
    BOOL _isAgreeService;
    BOOL _isAgreeSecrecy;
}
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UITextField *nameTd;
@property (weak, nonatomic) IBOutlet UITextField *phoneTd;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView2;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *descLb1;
@property (weak, nonatomic) IBOutlet UILabel *descLb2;

@end

@implementation DDProductNextOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请试用";
    
    _commitButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _commitButton.layer.shadowOffset = CGSizeMake(0,3);
    _commitButton.layer.shadowRadius = 6;
    _commitButton.layer.shadowOpacity = 1;
    _commitButton.layer.cornerRadius = 20;
    
    _descLb1.attributedText = [self getAttText:@"请详细阅读" textLas:@"《三特科技服务协议》"];
    _descLb2.attributedText = [self getAttText:@"请详细阅读" textLas:@"《三特科技保密协议》"];
}



- (IBAction)buttonDidClick:(UIButton *)sender {
    // 地区选择
    if (sender.tag == 0) {
        @weakify(self)
        [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity
                                           defaultSelected:@[]
                                              isAutoSelect:NO
                                                themeColor:nil
                                               resultBlock:^(BRProvinceModel *province,
                                                             BRCityModel *city,
                                                             BRAreaModel *area) {
                                                   @strongify(self)
                                                   if (!self) return ;
                                                   self->_cityCode = city.code;
                                                   self.addressLb.text = [NSString stringWithFormat:@"%@ %@",province.name,city.name];
                                                   self.addressLb.textColor =UIColorHex(0x131313);
                                               } cancelBlock:^{
                                                   
                                               }];

    }else if (sender.tag == 1) {
        DDProductAgreeServiceVc * vc = [DDProductAgreeServiceVc new];
        vc.url = [NSString stringWithFormat:@"%@:%@/supervisor/manager/userProtocolDetail",DDAPP_URL,DDPort8003];
        vc.serviceName = @"《三特科技服务协议》";
        @weakify(self)
        vc.argeeServiceBlock = ^(BOOL agree) {
            @strongify(self)
            self->_isAgreeService = agree;
            self.descLb1.attributedText = [self getAttText:@"我已仔细阅读并同意" textLas:@"《三特科技服务协议》"];
            [self.selectedImageView1 setImage:[UIImage imageNamed:@"icon_order_selected"]];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (sender.tag == 2) {
        DDProductAgreeServiceVc * vc = [DDProductAgreeServiceVc new];
        vc.url = [NSString stringWithFormat:@"%@:%@/supervisor/manager/userContractDetail",DDAPP_URL,DDPort8003];
        vc.serviceName = @"《三特科技保密合同》";
        @weakify(self)
        vc.argeeServiceBlock = ^(BOOL agree) {
            @strongify(self)
            self->_isAgreeSecrecy = agree;
            self.descLb2.attributedText = [self getAttText:@"我已仔细阅读并同意" textLas:@"《三特科技保密协议》"];
            [self.selectedImageView2 setImage:[UIImage imageNamed:@"icon_order_selected"]];
        };

        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSAttributedString * )getAttText:(NSString *)text textLas:(NSString *)last{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: UIColorHex(0x131313)}];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:last attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: UIColorHex(0x2996EB)}];
    [string appendAttributedString:string1];
    return string;
}



- (IBAction)commitButtonDidClick:(UIButton *)sender {
    if (_cityCode.length == 0) {
        [DDHub hub:@"请选择地区" view:self.view];
        return;
    }
    
    if (_nameTd.text.length == 0) {
        [DDHub hub:@"请输入联系人" view:self.view];
        return;
    }
    
    if (_phoneTd.text.length != 11) {
        [DDHub hub:@"请输入有效的联系方式" view:self.view];
        return;
    }
    if (!_isAgreeService) {
        [DDHub hub:@"请先阅读《三特科技服务协议》" view:self.view];
        return;
    }
    if (!_isAgreeSecrecy) {
        [DDHub hub:@"请先阅读《三特科技保密合同》" view:self.view];
        return;
    }
    //
    NSDictionary * dic = @{@"userLinkman" : _nameTd.text,
                           @"userLinkmanPhone" : _phoneTd.text,
                           @"orderArea" : _cityCode,
                           @"orderNumber" : _orderNumber
                           };
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:[NSString stringWithFormat:@"/tss/orders/generateOrders?token=%@",[DDUserManager share].user.token]
                         body:[dic modelToJSONString]
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub dismiss:self.view];
                           DDOrderDetailVc * vc = [DDOrderDetailVc new];
                           vc.type = 1;
                           vc.hidesBottomBarWhenPushed = NO;
                           vc.orderId = self.orderNumber;
                           vc.title = @"订单详情";
                           [DDAppManager gotoVC:vc navigtor:self.navigationController];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

@end
