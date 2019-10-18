//
//  DDUserInfoVC.m
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDUserInfoVC.h"
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
#import "DDUserBindPhoneVC.h"

@interface DDUserInfoVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _currentIdCard;
    NSString *_idcardFontURL;// 身份证正面
    NSString *_idcardBackURL;// 身份背面
    NSString *_identificationCardNumber;// 身份证号码
    NSString *_expiryDate; // 有效期
    NSString *_name;// 名字
    NSString *_sex;
    NSString * _address;
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) DDIDCardView* idCardView;
@property (nonatomic,strong) UIViewController* idCardVC;
@end

@implementation DDUserInfoVC

- (void)dealloc{
    self.idCardVC = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    
    [self setupBaiduAi];
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorHex(0xefefef);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDUserAvatarCell" bundle:nil] forCellReuseIdentifier:@"DDUserAvatarCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDBaseCell" bundle:nil] forCellReuseIdentifier:@"DDBaseCellId"];
    }
    return _tableView;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[DDUserManager share] getUserInfo:^{
        
    }];
}

// 身份证申请认证
- (void)applyIdentificationCardVerfiyRequest{
    if (_idcardFontURL.length == 0) {
        [DDHub hub:@"请添加身份证正面照" view:self.view];
        [self modifyIdCard];
        [self.idCardView setIconImage1:nil];
        return;
    }
    if (_idcardBackURL.length == 0) {
        [DDHub hub:@"请添加身份证反面照" view:self.view];
        [self modifyIdCard];
        [self.idCardView setIconImage2:nil];
        return;
    }
    if (_name.length == 0 || _identificationCardNumber.length == 0) {
        [DDHub hub:@"身份证验证失败，请重新添加认证" view:self.view];
        [self modifyIdCard];
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
                           [DDHub hub:@"申请成功" view:self.view];
                           [[DDUserManager share] getUserInfo:^{
                               [self.tableView reloadData];
                           }];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
    
}

// 申请实名认证
- (void)setupBaiduAi{

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
            self->_address = [result valueForKeyPath:@"words_result.住址.words"];
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
            [self modifyIdCard];
        }];
    });
}



// 修改资料，网络请求
- (void)updateUserNetwork:(NSString *)body{
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/uas/user/user/userInfo/updateUserInfo?token=",
                                       [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [DDHub hub:@"修改成功" view:self.view];
                           [[DDUserManager share] getUserInfo:^{
                               [self.tableView reloadData];
                           }];
                       }else {
                           [DDHub hub:@"修改失败！" view:self.view];
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
    actionSheet.configuration.allowEditImage = YES;
    actionSheet.configuration.editAfterSelectThumbnailImage = YES;
    actionSheet.configuration.clipRatios = @[@{@"1" : @(1)}];
    
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


// 修改性别
- (void)modifySex{
    @weakify(self)
    [BRStringPickerView showStringPickerWithTitle:@"修改性别"
                                       dataSource:@[@"男",@"女"]
                                  defaultSelValue:nil
                                      resultBlock:^(NSString * selectValue) {
                                          @strongify(self)
                                          if (!self) return ;
                                          NSInteger sex = [selectValue isEqualToString:@"男"] ? 1 : 2;
                                          [DDHub hub:self.view];
                                          NSString * body = [NSString stringWithFormat:@"{\"sex\" : \"%zd\" }",sex];
                                          [self updateUserNetwork:body];
    }];
}

// 修改身份证
- (void)modifyIdCard{
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:self.idCardView preferredStyle:TYAlertControllerStyleActionSheet];
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

// 修改昵称
- (void)modifyNickName{
    DDAlertSheetView * sheetView = [DDAlertSheetView createViewFromNib];
    @weakify(self)
    sheetView.event = ^(NSString * _Nonnull text) {
        @strongify(self)
        if (!self) return ;
        if (text.length > 10) {
            [DDHub hubText:@"昵称长度不能大于10"];
            return;
        }
        [DDHub hub:self.view];
        NSString * body = [NSString stringWithFormat:@"{\"nickname\" : \"%@\" }",text];
        [self updateUserNetwork:body];
    };
    sheetView.titleLb.text = @"修改昵称";
    sheetView.textLb.text = yyTrimNullText([DDUserManager share].user.nickname);
    sheetView.textLb.placeholder = @"请输入您的昵称";
    if (iPhoneXAfter) {
        sheetView.height = 190;
    }
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:sheetView preferredStyle:TYAlertControllerStyleActionSheet];
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

// 修改地址
- (void)modifyAdress{
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
                                               [DDHub hub:self.view];
                                               NSString * body = [NSString stringWithFormat:@"{\"area\" : \"%@\" }",city.name];
                                               [self updateUserNetwork:body];
                                           } cancelBlock:^{
                                               
                                           }];
}

// 修改邮箱
- (void)modifyEmail{
    @weakify(self)
    DDAlertSheetView * sheetView = [DDAlertSheetView createViewFromNib];
    sheetView.event = ^(NSString * _Nonnull text) {
        @strongify(self)
        if (!self) return ;
        if (!text || ![text isInvalidEmail]){
            [DDHub hub:@"邮箱格式不对" view:self.view];
            return;
        }
        [DDHub hub:self.view];
        NSString * body = [NSString stringWithFormat:@"{\"email\" : \"%@\" }",text];
        [self updateUserNetwork:body];
        
    };
    sheetView.titleLb.text = @"修改邮箱";
    sheetView.textLb.placeholder = @"请输入您邮箱";
    sheetView.textLb.text = yyTrimNullText([DDUserManager share].user.email);
    if (iPhoneXAfter) {
        sheetView.height = 190;
    }
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:sheetView preferredStyle:TYAlertControllerStyleActionSheet];
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) return 1;
    if (section == 1) return 5;
    return [DDUserManager share].user.userType == DDUserTypeSystem ?  3 : 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDUser * user =  [DDUserManager share].user;
    
    if (indexPath.section == 0) {
        DDUserAvatarCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDUserAvatarCellId"];
        NSString * icon = yyTrimNullText(user.userHeadImage);
        if ([icon hasPrefix:@"http"]) {
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:icon]];
        }else {
            cell.iconView.image = [UIImage imageNamed:[DDUserManager share].userPlaceImage];
        }
        return cell;
    }else {
        DDBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDBaseCellId"];
        NSString * title = @"";
        NSString * content = @"";
        cell.dictView.hidden = NO;
        if (indexPath.section == 1) {
            NSArray * titles = @[@"昵称",@"所在地",@"手机号",@"个人邮箱",@"实名认证"];
            NSString * phone = yyTrimNullText(user.phone);
            if (phone.length > 5) {
                phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 3) withString:@"***"];
            }
            NSString * status = @"未认证";
            if (user.realAuthentication == 1){
                status = @"已认证";
            }else if(user.realAuthentication == 2) {
                status = @"未通过";
            }
            NSArray * contents = @[yyTrimNullText(user.nickname),
//                                   yyTrimNullText(user.sex),
                                   yyTrimNullText(user.area),
                                   phone,
                                   yyTrimNullText(user.email),
                                   status];
            
            title = titles[indexPath.row];
            content = contents[indexPath.row];
            if (indexPath.row == 3) {
                cell.dictView.hidden = YES;
            }
            if (indexPath.row == 1) {
                cell.dictView.hidden = YES;
            }
            if (user.enterpriseAuthentication &&
                indexPath.row == 5) {

            }
        }else {
            cell.dictView.hidden = YES;
            NSArray * titles = @[@"所属企业",@"企业认证",@"所在行业"];
            NSString * status = @"未认证";
            if (user.enterpriseAuthentication == 1){
                status = @"已认证";
            }else if(user.enterpriseAuthentication == 2) {
                status = @"未通过";
            }else if([DDUserManager share].user.enterpriseAuthentication == 0) {
                status = @"认证中";
            }
            NSArray * contents = @[yyTrimNullText(user.enterpriseName),
                                   status,
                                   yyTrimNullText(user.industry)];
            title = titles[indexPath.row];
            content = contents[indexPath.row];
            
        }
        cell.nameLB.text = title;
        cell.contentLb.text = content;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) return 80;
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        // 上传图片
        [self showPhotoActionSheetCompletion:^(bool suc, NSString *url) {
            if (suc) {
                NSString * body = [NSString stringWithFormat:@"{\"userHeadImage\" : \"%@\" }",url];
                [self updateUserNetwork:body];
            }else {
                [DDHub hub:@"修改头像失败！" view:self.view];
            }
        }];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
//            DDUserBindPhoneVC * vc = [DDUserBindPhoneVC new];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 0) {
            [self modifyNickName];
        }else if (indexPath.row == 1) {
            [self modifyAdress];
        }else if (indexPath.row == 3) {
            [self modifyEmail];
        }else if (indexPath.row == 4) {
            // 实名认证
            if ([DDUserManager share].user.realAuthentication == 1) {
                DDIdCardInfoVC * vc = [DDIdCardInfoVC new];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [self modifyIdCard];
            }
        }
    }
}
@end
