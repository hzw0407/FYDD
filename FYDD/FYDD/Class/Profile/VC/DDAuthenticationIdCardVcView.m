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

@interface DDAuthenticationIdCardVcView (){
    NSInteger _currentIdCard;
    NSString *_idcardFontURL;// 身份证正面
    NSString *_idcardBackURL;// 身份背面
    NSString *_identificationCardNumber;// 身份证号码
    NSString *_expiryDate; // 有效期
    NSString *_name;// 名字
    NSString *_sex;
    NSString * _address;
}
@property (nonatomic,strong) DDIDCardView* idCardView;
@property (nonatomic,strong) UIViewController* idCardVC;
@end

@implementation DDAuthenticationIdCardVcView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.idCardView];
    [self.idCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(@0);
        make.top.mas_equalTo(@-49);
        make.height.mas_equalTo(@410);
    }];
    self.title = @"实名认证";
    self.view.backgroundColor = UIColorHex(0xf5f5f5);
}
// 身份证认证
- (DDIDCardView *)idCardView{
    if (!_idCardView) {
        _idCardView = [DDIDCardView createViewFromNib];
        if (iPhoneXAfter) {
            _idCardView.height = 428;
        }
        @weakify(self)
        _idCardView.event = ^(NSInteger index) {
            @strongify(self)
            if (!self) return ;
            // 认证
            if (index == 2) {
                [self applyIdentificationCardVerfiyRequest];
            }else {
                self->_currentIdCard = index;
                // 百度Ai
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
                
            }
        };
    }
    return _idCardView;
}

- (void)applyIdentificationCardVerfiyRequest{
    if (_idcardFontURL.length == 0) {
        [DDHub hub:@"请添加身份证正面照" view:self.view];
        [self.idCardView setIconImage1:nil];
        return;
    }
    if (_idcardBackURL.length == 0) {
        [DDHub hub:@"请添加身份证反面照" view:self.view];
        [self.idCardView setIconImage2:nil];
        return;
    }
    if (_name.length == 0 || _identificationCardNumber.length == 0) {
        [DDHub hub:@"身份证验证失败，请重新添加认证" view:self.view];
        return;
    }
    NSDateFormatter * formate = [[NSDateFormatter alloc] init];
    formate.dateFormat = @"yyyyMMdd";
    NSDate * date = [formate dateFromString:_expiryDate];
    
    NSDateFormatter * formate1 = [[NSDateFormatter alloc] init];
    formate1.dateFormat = @"yyyy-MM-dd";
    
    NSString * body = [NSString stringWithFormat:@"{\"name\" : \"%@\" , \"identificationCardNumber\" : \"%@\" , \"positiveImage\" : \"%@\" , \"sideImage\" : \"%@\", \"expiryDate\" : \"%@\",\"sex\" : \"%@\",\"address\" : \"%@\"}",_name,_identificationCardNumber,_idcardFontURL,_idcardBackURL,[formate1 stringFromDate:date],_sex,_address];
    
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
                           [DDHub hub:@"申请失败！" view:self.view];
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
    [self.idCardVC dismissViewControllerAnimated:YES completion:nil];
    self.idCardVC = nil;
    if ([result isKindOfClass:[NSDictionary class]]) {
        if(self->_currentIdCard == 0) {
            self->_name = [result valueForKeyPath:@"words_result.姓名.words"];
            self->_identificationCardNumber = [result valueForKeyPath:@"words_result.公民身份号码.words"];
            self->_sex = [result valueForKeyPath:@"words_result.性别.words"];
            self->_address = [result valueForKeyPath:@"words_result.地址.words"];
        }else {
            self->_expiryDate = [result valueForKeyPath:@"words_result.失效日期.words"];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        if (!self) return ;
        [self uploadImage:image completion:^(bool suc, NSString *url) {
            if (suc) {
                [DDHub dismiss:self.view];
                if (self->_currentIdCard == 0){
                    [self.idCardView setIconImage1:url];
                    self.idCardView.cardName.text = self->_name;
                    self.idCardView.cardNoLb.text = self->_identificationCardNumber;
                    self->_idcardFontURL = url;
                }else {
                    [self->_idCardView setIconImage2:url];
                    self->_idcardBackURL = url;
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


@end
