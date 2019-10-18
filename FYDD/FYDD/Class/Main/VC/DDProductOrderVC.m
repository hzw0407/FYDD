//
//  DDProductOrderVC.m
//  FYDD
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProductOrderVC.h"
#import "DDOrderPayVC.h"
#import "DDOrderProductDateCell.h"
#import "DDOrderProductInfoCell.h"
#import "DDOrderCarryCell.h"
#import "DDOrderUserCell.h"
#import "DDGradeModel.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "BRAddressPickerView.h"
#import "DDOnlineModel.h"
#import <UITableView+YYAdd.h>
#import "DDOrderPayVC.h"
#import "DDAlertInputView.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import "DDOrderVC.h"
@interface DDProductOrderVC ()<UITableViewDelegate,UITableViewDataSource> {
    // 选择规格
    DDProductPriceItem * _priceItem;
    NSMutableArray * _checkUsers;
    DDGradeModel * _currentGrade;
    NSString * _contactUser;
    NSString * _contactPhone;
    NSString * _cityName;
    NSString * _cityCode;
    DDOnlineModel * _onlineUser;
    BOOL _expandOnline;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDProductOrderVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 30;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = (YYScreenSize().height /  900) * 210;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下单";
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_reward"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonDidClick)];
    [self.view addSubview:self.tableView];
    if (iPhoneXAfter) {
        _cons.constant =  30;
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(iPhoneXAfter ? @-85 : @-55 );
    }];
    
    if (_productItem.list.count > 0) {
        _priceItem = _productItem.list[0];
    }
    [self updatePriceUI];
    [self getOrderCheckUser];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _cityName = [DDUserManager share].user.area;
    _cityCode = [[DDAppManager share] getCityNameWithCode:_cityName];
    _expandOnline = NO;
}

// 获取实施方等级
- (void)getOrderCheckUser{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:@"/uas/user/online/member/getByRedis"
                         body:@""
                   completion:^(NSInteger code, NSString *message, NSArray * data) {
                       @strongify(self)
                       if(!self) return ;
                       if (code == 200) {
                           self->_checkUsers = @[].mutableCopy;
                           if ([data isKindOfClass:[NSArray class]]) {
                               for (NSInteger i =0; i < data.count; i++) {
                                   DDGradeModel * model = [DDGradeModel modelWithJSON:data[i]];
                                   if (i == 0) {
                                       model.isSelected = YES;
                                   }
                                   [self->_checkUsers addObject:model];
                                   if (i == 0)
                                       self->_currentGrade = model;
                               }
                           }
                           [self updatePriceUI];
                           [self.tableView reloadData];
                       }
                   }];
    
}

- (void)updatePriceUI{
    if (_priceItem) {
        
        double price = _priceItem.salePrice + _currentGrade.commissionFee;
        if (_expandOnline) {
            price = _priceItem.salePrice + _onlineUser.commissionFee;
        }
        NSMutableAttributedString *priceAtt = [NSMutableAttributedString new];
        NSMutableAttributedString *attribut1 = [[NSMutableAttributedString alloc]initWithString:@"费用总额"];
        [attribut1 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0,4)];
        NSString * text2 = [NSString stringWithFormat:@"  ¥%.2f",price];
        NSMutableAttributedString *attribut2 = [[NSMutableAttributedString alloc]initWithString:text2];
        [attribut2 addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0,text2.length)];
        [priceAtt appendAttributedString:attribut1];
        [priceAtt appendAttributedString:attribut2];
        _priceLb.attributedText = priceAtt;
    }
}

- (void)rightButtonDidClick{
    @weakify(self)
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType,
                                                                             NSDictionary *userInfo) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.productItem.shareTitle
                                                                                 descr:self.productItem.shareContext
                                                                             thumImage:self.productItem.shareImage];
        shareObject.webpageUrl = self.productItem.productSharePath;
        messageObject.shareObject = shareObject;
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            @strongify(self)
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                [DDHub hub:@"分享成功" view:self.view];
            }
        }];
    }];
}
// 去支付
- (IBAction)payEvent {
    // 请选择实施方
    if (_expandOnline && !_onlineUser) {
        [DDHub hub:@"请选定实施方!" view:self.view];
        return;
    }
    if (_contactUser.length == 0) {
        [DDHub hub:@"请输入实施联系人!" view:self.view];
        return;
    }
    if (_contactPhone.length != 11) {
        [DDHub hub:@"请输入11位有效的手机联系方式!" view:self.view];
        return;
    }
    if (_cityName.length == 0) {
        [DDHub hub:@"请选择服务城市!" view:self.view];
        return;
    }

    NSString* implentationId = _expandOnline ? [NSString stringWithFormat:@"%zd",_onlineUser.onlineId] : @"";
    // 实施方等级id
    NSString *onlineUserId = _expandOnline ? @"" : [NSString stringWithFormat:@"%zd",_currentGrade.gradeId];
    
    NSString * body = @"";
    if (!_expandOnline){
        body = [NSString stringWithFormat:@"{\"productId\" : \"%zd\" , \"onlineUserId\" : \"%@\" , \"userLinkman\" : \"%@\" , \"userLinkmanPhone\" : \"%@\", \"packageId\" : \"%zd\" , \"orderArea\" : \"%@\"}",_productItem.itemId,onlineUserId,_contactUser,_contactPhone,_priceItem.priceId,_cityCode];
    }else {
        body = [NSString stringWithFormat:@"{\"productId\" : \"%zd\" ,\"implementationMember\" : %@, \"userLinkman\" : \"%@\" , \"userLinkmanPhone\" : \"%@\", \"packageId\" : \"%zd\" , \"orderArea\" : \"%@\"}",_productItem.itemId, implentationId,_contactUser,_contactPhone,_priceItem.priceId,_cityCode];
    }

    
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/tss/orders/generateOrders?token=", [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message,id data) {
                       @strongify(self)
                       if(!self) return ;
                       if (code == 200 || code == 2001) {
                           [DDHub dismiss:self.view];
                           if ([[NSString stringWithFormat:@"%@",data[@"extensionMember"]] integerValue]){
                               [self gotoOrderPay:[NSString stringWithFormat:@"%@",data[@"orderNumber"]]];
                           }else {
                               [self bindingRewartCode:[NSString stringWithFormat:@"%@",data[@"orderNumber"]]];
                           }
                           
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
    

}

- (void)bindingRewartCode:(NSString *)orderNumber{
    @weakify(self)
    [DDAlertInputView showEvent:^(NSString *text) {
        [DDHub hub:self.view];
        [[DDAppNetwork share] get:YES
                             path:[NSString stringWithFormat:@"/tss/orders/setOrdersExtension?orderNumber=%@&extensionCode=%@",orderNumber,text]
                             body:@""
                       completion:^(NSInteger code, NSString *message, id data) {
                           @strongify(self)
                           if (!self) return ;
                           [DDHub dismiss:self.view];
                           if (code == 200) {
                              [self gotoOrderPay:orderNumber];
                           }else {
                               [DDHub hub:message view:self.view];
                           }
                       }];
        
    } cancelEvent:^{
        [self gotoOrderPay:orderNumber];
    }];
}

// gotoOrderPay
- (void)gotoOrderPay:(NSString *)orderNumber{
    DDOrderPayVC * vc = [DDOrderPayVC new];
    vc.orderId = orderNumber;
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSMutableArray * vcd = [NSMutableArray new];
    [vcd addObject:vcArray[0]];
    [vcd addObject:[DDOrderVC new]];
    [vcd addObject:vc];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController setViewControllers:vcd animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorHex(0xEFEFF6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDOrderProductDateCell" bundle:nil] forCellReuseIdentifier:@"DDOrderProductDateCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDOrderProductInfoCell" bundle:nil] forCellReuseIdentifier:@"DDOrderProductInfoCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDOrderCarryCell" bundle:nil] forCellReuseIdentifier:@"DDOrderCarryCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDOrderUserCell" bundle:nil] forCellReuseIdentifier:@"DDOrderUserCellId"];
    }
    return _tableView;
}

- (void)chooseCity{
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
                                               self->_cityName = city.name;
                                               self->_cityCode = city.code;
                                               [self.tableView reloadData];
                                           } cancelBlock:^{
                                               
                                           }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.row == 0) {
        DDOrderProductDateCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderProductDateCellId"];
        cell.items = _productItem.list;
        cell.event = ^(DDProductPriceItem *item) {
            @strongify(self)
            self->_priceItem = item;
            [self.tableView reloadData];
            [self updatePriceUI];
        };
        return cell;
    }else if (indexPath.row == 1){
        DDOrderProductInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderProductInfoCellId"];
        cell.price = _priceItem.salePrice;
        cell.nameLb.text = _productItem.productName;
        return cell;
    }else if (indexPath.row == 2) {
        DDOrderCarryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderCarryCellId"];
        cell.items = _checkUsers;
        cell.price = _currentGrade.commissionFee;
        cell.event = ^(NSInteger index) {
             @strongify(self)
            if (!self) return ;
            if (index == 4) {
                self->_expandOnline = !self->_expandOnline;
                if (!self->_expandOnline) {
                    self->_onlineUser.isSelected = NO;
                }
                [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
            }else {
                self->_currentGrade = self->_checkUsers[index];
                [self updatePriceUI];
                [self.tableView reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
            }
        };
        return cell;
    }else {
        DDOrderUserCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDOrderUserCellId"];
        cell.contactTd.text = _contactUser;
        cell.contactPhoneTd.text = _contactPhone;
        cell.cityLb.text = _cityName;
        cell.onlineUser = _onlineUser;
        cell.event = ^(NSInteger index) {
            @strongify(self)
            if (index == 1) {
                [self chooseCity];
                [self.view endEditing:YES];
            }else {
                self->_onlineUser.isSelected = !self->_onlineUser.isSelected;
                self->_expandOnline = self->_onlineUser.isSelected;
                [self updatePriceUI];
                [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
            }
        };
        cell.textChange = ^(NSString *text, NSInteger key) {
            @strongify(self)
            if (key == 1) {
                self->_contactUser = text;
            }else if (key == 2) {
                self->_contactPhone = text;
            }
        };
        // 所有实施方
        cell.textBlock = ^(NSString * text) {
            @strongify(self)
            [self searchOnline:text];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return 160;
    if (indexPath.row == 1) return 110;
    if (indexPath.row == 2) return (_expandOnline) ? 92 : 233;
    if (indexPath.row == 3) return 400;
    return indexPath.row % 2 ? 200: 30;
}

// 搜索实施方
- (void)searchOnline:(NSString *)phone{
    if(phone.length != 11) {
        [DDHub hub:@"请输入11位有效的实施方手机号码!" view:self.view];
        return;
    }
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/uas/user/online/getUserOnlineByPhone?phone=", phone)
                         body:@""
                   completion:^(NSInteger code, NSString *message,id data) {
                       @strongify(self)
                       if(!self) return ;
                       if (code == 200 || code == 2001) {
                           [DDHub dismiss:self.view];
                           self->_onlineUser = [DDOnlineModel modelWithJSON:data];
                           [self.tableView reloadData];
                       }else {
                           self->_onlineUser = nil;
                           [DDHub hub:@"未搜到实施方" view:self.view];
                       }
                   }];
}

@end
