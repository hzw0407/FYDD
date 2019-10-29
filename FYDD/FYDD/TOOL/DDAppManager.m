//
//  DDAppManager.m
//  FYDD
//
//  Created by mac on 2019/2/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDAppManager.h"
#import <WXApi.h>
#import "BRAddressModel.h"

@interface  DDAppManager()
@property (nonatomic,strong) NSArray * dataCitys;
@property (nonatomic,strong) NSArray * provices;
@end

@implementation DDAppManager

+ (instancetype)share{
    static dispatch_once_t onceToken;
    static DDAppManager * _manager;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
        _manager->_cache = [[YYCache alloc] initWithName:@"DD_FY_Cache"];
    });
    return _manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {

        _appTintColor = UIColorHex(0x2996EB);
        _navigationBarBgColor = UIColorHex(0x2996EB);
        _navigationTintColor = UIColorHex(0x2996EB);
    }
    return self;
}

- (BOOL)isShowWelcome{
    if ([_cache objectForKey:@"isShowWelcome"]) {
        return  false;
    }else {
        [_cache setObject:@"true" forKey:@"isShowWelcome"];
        return true;
    }
}

+ (void)gotoVC:(UIViewController *)vc navigtor:(UINavigationController *)nav{
    [self gotoVC:vc navigtor:nav animated:YES];
}


+ (void)gotoVC:(UIViewController *)vc navigtor:(UINavigationController *)nav animated:(BOOL)animated{
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:nav.viewControllers];
    if (vcArray.count < 2) {
        return;
    }
    NSMutableArray * vcd = [NSMutableArray new];
    [vcd addObject:vcArray[0]];
    [vcd addObject:vc];
    vc.hidesBottomBarWhenPushed = YES;
    [nav setViewControllers:vcd animated:animated];
}

+ (void)popVc:(NSString *)targetClass navigtor:(UINavigationController *)nav{
    Class classt = NSClassFromString(targetClass);
    if (!classt) return;
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:nav.viewControllers];
    
    UIViewController * vc = nil;
    for (UIViewController * containerVc in vcArray) {
        if ([containerVc isKindOfClass:classt]) {
            vc = containerVc;
        }
    }
    if (vc) {
        [nav popToViewController:vc animated:YES];
    }
}

+ (void)share:(NSString *)code title:(NSString *)title remark:(NSString*)remark iconImage:(NSString *)image{
    
}



- (void)loadData {
    // 如果外部没有传入地区数据源，就使用本地的数据源
    if (!self.dataCitys || self.dataCitys.count == 0) {
        /*
         先拿到最外面的 bundle。
         对 framework 链接方式来说就是 framework 的 bundle 根目录，
         对静态库链接方式来说就是 target client 的 main bundle，
         然后再去找下面名为 BRPickerView 的 bundle 对象。
         */
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"BRPickerView" withExtension:@"bundle"];
        NSBundle *plistBundle = [NSBundle bundleWithURL:url];
        
        NSString *filePath = [plistBundle pathForResource:@"BRCity" ofType:@"plist"];
        NSArray *dataSource = [NSArray arrayWithContentsOfFile:filePath];
        self.dataCitys = dataSource;
    }
    
    [self parseDataSource];
}

#pragma mark - 解析数据源
- (void)parseDataSource {
    NSMutableArray *tempArr1 = [NSMutableArray array];
    for (NSDictionary *proviceDic in self.dataCitys) {
        BRProvinceModel *proviceModel = [[BRProvinceModel alloc]init];
        proviceModel.code = proviceDic[@"code"];
        proviceModel.name = proviceDic[@"name"];
        proviceModel.index = [self.dataCitys indexOfObject:proviceDic];
        NSArray *citylist = proviceDic[@"citylist"];
        NSMutableArray *tempArr2 = [NSMutableArray array];
        for (NSDictionary *cityDic in citylist) {
            BRCityModel *cityModel = [[BRCityModel alloc]init];
            cityModel.code = cityDic[@"code"];
            cityModel.name = cityDic[@"name"];
            cityModel.index = [citylist indexOfObject:cityDic];
            NSArray *arealist = cityDic[@"arealist"];
            NSMutableArray *tempArr3 = [NSMutableArray array];
            for (NSDictionary *areaDic in arealist) {
                BRAreaModel *areaModel = [[BRAreaModel alloc]init];
                areaModel.code = areaDic[@"code"];
                areaModel.name = areaDic[@"name"];
                areaModel.index = [arealist indexOfObject:areaDic];
                [tempArr3 addObject:areaModel];
            }
            cityModel.arealist = [tempArr3 copy];
            [tempArr2 addObject:cityModel];
        }
        proviceModel.citylist = [tempArr2 copy];
        [tempArr1 addObject:proviceModel];
    }
    self.provices = [tempArr1 copy];
}

- (NSString *)getCityCode:(NSString *)code{
    if (!_provices) {
        [self loadData];
    }
    NSString * name = @"";
    for (BRProvinceModel * item in _provices) {
        for (BRCityModel * city in item.citylist) {
            if ([city.code isEqualToString:code]){
                return city.name;
            }
        }
    }
    return name;
}

- (NSString *)getCityNameWithCode:(NSString *)name{
    if (!_provices) {
        [self loadData];
    }
    NSString * names = @"";
    for (BRProvinceModel * item in _provices) {
        for (BRCityModel * city in item.citylist) {
            if ([city.name isEqualToString:name]){
                return city.code;
            }
        }
    }
    return names;
}

@end

NSString * yyTrimNullText(NSString *text){
    if (text == nil || text == NULL) {
        return @"";
    }
    if ([text isKindOfClass:[NSString class]]){
        if ([text isEqualToString:@"<null>"]) {
            return @"";
        }
        return text;
    }else {
        if ([[NSString stringWithFormat:@"%@",text] isEqualToString:@"<null>"]) {
            return @"";
        }
        return [NSString stringWithFormat:@"%@",text];
    }
}
// 订单状态转换
DDOrderStatus convertOrderStatus(NSString *status,NSInteger isCompanyFirst) {
    DDOrderStatus type =  DDOrderStatusCancel;
    if ([status isEqualToString:@"001"]) {
        type =  DDOrderStatusWaitCommit;
    }else if ([status isEqualToString:@"010"]) {
        type =  DDOrderStatusWaitPay;
    }else if ([status isEqualToString:@"020"]) {
        type =  DDOrderStatusPaySuccess;
    }else if ([status isEqualToString:@"021"]) {
        type =  DDOrderStatusPay;
    }else if ([status isEqualToString:@"022"]) {
        type =  DDOrderStatusPayFail;
    }else if ([status isEqualToString:@"030"]) {
        type =  DDOrderStatusLeaflets;
    }else if ([status isEqualToString:@"031"]) {
        type =  DDOrderStatusOrderTaking;
    }else if ([status isEqualToString:@"040"]) {
        type =  DDOrderStatusService;
    }else if ([status isEqualToString:@"050"]) {
        type =  DDOrderStatusCarry;
    }else if ([status isEqualToString:@"051"]) {
        type =  DDOrderStatusChangeCarryUser;
    }else if ([status isEqualToString:@"060"]) {
        type =  DDOrderStatusWaitComment;
    }else if ([status isEqualToString:@"062"]) {
        type =  DDOrderStatusWaitPay;
    }else if ([status isEqualToString:@"070"]) {
        type =  DDOrderStatusFinish;
    }else {
        if (isCompanyFirst == 1) {
            //首次下单
            type = DDOrderWaitReceipt;
        }else {
            //非首次
            type = DDOrderStatusWaitPay;
        }
    }
    return type;
    
}

/*
 DDOrderStatusCancel,
 DDOrderStatusWaitCommit,
 DDOrderStatusCreate,
 DDOrderStatusPaySuccess,
 DDOrderStatusPay,
 DDOrderStatusPayFail,
 DDOrderStatusLeaflets,
 DDOrderStatusOrderTaking,
 DDOrderStatusService,
 DDOrderStatusCarry,
 DDOrderStatusChangeCarryUser,
 DDOrderStatusWaitComment,
 DDOrderStatusWaitPay,
 DDOrderStatusFinish
 */


