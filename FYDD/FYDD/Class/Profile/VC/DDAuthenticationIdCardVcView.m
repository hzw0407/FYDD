//
//  DDAuthenticationIdCardVcView.m
//  FYDD
//
//  Created by mac on 2019/4/18.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDAuthenticationIdCardVcView.h"
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "DDUserAvatarCell.h"
#import "DDBaseCell.h"
#import "BRStringPickerView.h"
#import "UIView+TYAlertView.h"
#import "DDIDCardView.h"
#import "DDAlertSheetView.h"
#import "BRAddressPickerView.h"
#import <UIImage+YYAdd.h>
#import <NSString+YYAdd.h>
#import <FSCalendar/FSCalendar.h>
#import "DDIdCardInfoVC.h"
#import <Masonry.h>

@interface DDAuthenticationIdCardVcView ()<DDIDCardViewDelegate>

@property (nonatomic,strong) DDIDCardView* idCardView;
@property (nonatomic,strong) UIViewController* idCardVC;
@property (nonatomic, assign) NSInteger currentIdCard;//0当前识别的是正面 1是背面
@property (nonatomic, copy) NSString *idcardFontURL;//正面照片
@property (nonatomic, copy) NSString *idcardBackURL;//背面照片
@property (nonatomic, copy) NSString *identificationCardNumber;//身份证号码
@property (nonatomic, copy) NSString *name;//名字
@property (nonatomic, copy) NSString *expiryDate;//有效期
@property (nonatomic, copy) NSString *sex;//性别
@property (nonatomic, copy) NSString *address;//地址

@end

@implementation DDAuthenticationIdCardVcView
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.idCardView];
    [self.idCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view).offset(0);
    }];
    self.title = @"个人认证";
    self.view.backgroundColor = UIColorHex(0xf5f5f5);
}

#pragma mark - CustomMethod
//申请认证
- (void)applyIdentificationCardVerfiyRequest{
    if (self.idcardFontURL.length == 0) {
        [DDHub hub:@"请添加身份证正面照" view:self.view];
        return;
    }
    if (self.idcardBackURL.length == 0) {
        [DDHub hub:@"请添加身份证反面照" view:self.view];
        return;
    }
    if (self.name.length == 0 || self.identificationCardNumber.length == 0 || self.expiryDate.length == 0) {
        [DDHub hub:@"身份证验证失败，请重新添加认证" view:self.view];
        return;
    }
    NSDateFormatter * formate = [[NSDateFormatter alloc] init];
    formate.dateFormat = @"yyyyMMdd";
    NSDate * date = [formate dateFromString:self.expiryDate];
    
    NSDateFormatter * formate1 = [[NSDateFormatter alloc] init];
    formate1.dateFormat = @"yyyy-MM-dd";
    
    NSString * body = [NSString stringWithFormat:@"{\"name\" : \"%@\" , \"identificationCardNumber\" : \"%@\" , \"positiveImage\" : \"%@\" , \"sideImage\" : \"%@\", \"expiryDate\" : \"%@\",\"sex\" : \"%@\",\"address\" : \"%@\"}",self.name,self.identificationCardNumber,self.idcardFontURL,self.idcardBackURL,[formate1 stringFromDate:date],self.sex,self.address];
    
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/uas/user/real/name/user/userInfo/updateUserAuthentication?token=",
                                       [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [[DDUserManager share] getUserInfo:^{
                               
                           }];
                           [DDHub hub:@"申请成功" view:self.view];
                           [self.navigationController popViewControllerAnimated:YES];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
    
}

- (void)detectIdCardFrontFromImage:(UIImage *)image{
    @weakify(self)
    if (_currentIdCard == 0 ){
        [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                     withOptions:nil
                                                  successHandler:^(id result){
                                                      @strongify(self)
                                                      if (!self) return ;
                                                      [self detectIdCardFinish:result image:image];
                                                  }
                                                     failHandler:nil];
    }else {
        [[AipOcrService shardService] detectIdCardBackFromImage:image withOptions:nil successHandler:^(id result) {
            @strongify(self)
            if (!self) return ;
            [self detectIdCardFinish:result image:image];
        } failHandler:^(NSError *err) {
            
        }];
    }
}

- (void)detectIdCardFinish:(id)result image:(UIImage *)image{
    @weakify(self)
//    [self.idCardVC dismissViewControllerAnimated:YES completion:nil];
    self.idCardVC = nil;
    if ([result isKindOfClass:[NSDictionary class]]) {
        if(self.currentIdCard == 0) {
            self.name = [result valueForKeyPath:@"words_result.姓名.words"];
            self.identificationCardNumber = [result valueForKeyPath:@"words_result.公民身份号码.words"];
            self.sex = [result valueForKeyPath:@"words_result.性别.words"];
            self.address = [result valueForKeyPath:@"words_result.地址.words"];
        }else {
//            self->_expiryDate = [result valueForKeyPath:@"words_result.失效日期.words"];
            self.expiryDate = [result valueForKeyPath:@"words_result.失效日期.words"];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        if (!self) return ;
        [self uploadImage:image completion:^(bool suc, NSString *url) {
            if (suc) {
                [DDHub dismiss:self.view];
                if (self.currentIdCard == 0){
                    NSDictionary *infoDic = @{@"name" : self.name,
                                              @"number" : self.identificationCardNumber,
                                              @"expiryDate" : self.expiryDate ? self.expiryDate : @"",
                                              @"url1" : url,
                                              @"url2" : self.idcardBackURL ? self.idcardBackURL : @"",
                    };
                    [self.idCardView refrehsInfoWithDic:infoDic];
                    self.idcardFontURL = url;
                }else {
                    NSDictionary *infoDic = @{@"name" : self.name ? self.name : @"",
                                              @"number" : self.identificationCardNumber ? self.identificationCardNumber : @"",
                                              @"expiryDate" : self.expiryDate,
                                              @"url1" : self.idcardFontURL ? self.idcardFontURL : @"",
                                              @"url2" : url,
                    };
                    [self.idCardView refrehsInfoWithDic:infoDic];
                    self.idcardBackURL = url;
                }
            }else {
                [DDHub hub:@"上传图片失败！" view:self.view];
            }
        }];
    });
}

// 上传图片
- (void)uploadImage:(UIImage*)image completion:(void (^)(bool suc ,NSString * url ) )completion{
    UIImage * imageUpload = [image imageByResizeToSize:CGSizeMake(1000, 1000)];
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] path:@"/uas/st/upload"
                        upload:imageUpload
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

#pragma mark - ClickMethod

#pragma mark - SystemDelegate

#pragma mark - CustomDelegate

#pragma mark - DDIDCardViewDelegate
//点击功能
- (void)clickIndex:(NSInteger)index {
    if (index == 0 || index == 1) {
        //扫描人像和国徽
        self.currentIdCard = index;
        @weakify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
        
                                       dispatch_get_main_queue(), ^{
                                           @strongify(self)
                                           if (!self.idCardVC){
                                               @weakify(self)
                                               self.idCardVC = [AipCaptureCardVC ViewControllerWithCardType:index == 0 ? CardTypeLocalIdCardFont :CardTypeLocalIdCardBack   andImageHandler:^(UIImage *image) {
                                                   @strongify(self)
                                                   [self detectIdCardFrontFromImage:image];
                                               }];
                                           }
                                           [self presentViewController: self.idCardVC animated:YES completion:^{}];
                                       });
    }else {
        //申请认证
        [self applyIdentificationCardVerfiyRequest];
    }
}

#pragma mark - GetterAndSetter
- (DDIDCardView *)idCardView {
    if (!_idCardView) {
        _idCardView = [[DDIDCardView alloc] initWithFrame:CGRectZero];
        _idCardView.delegate = self;
    }
    return _idCardView;
}






@end
