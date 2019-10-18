//
//  DDUserComanyInfoVC.m
//  FYDD
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDUserComanyInfoVC.h"
#import "DDUserAvatarCell.h"
#import "DDBaseCell.h"
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>
#import "BRStringPickerView.h"
#import "DDCommitCell.h"
#import "DDIndustryModel.h"
#import <UIImage+YYAdd.h>
#import "DDDownServceCell.h"
#import "DDAlertSheetView.h"
#import "UIView+TYAlertView.h"
#import "DDBaseInputCell.h"

@interface DDUserComanyInfoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * _industrys;
    NSArray * _industryNames;
    NSString *_currentIndustryname;
    NSString *_currentIndustryId;
    
    // 企业信息
    NSString * _enterpriseImgUrl;
    NSString * _serviceURL;
    BOOL _isEnterpriseImgUrl;
    
    NSString * _enterpriseName;
    NSString * _enterpriseAddress;
    NSString * _registrationNumber;
    NSString * _socialCreditCode;
    NSString * _legalRepresentative;
    NSString * _effectiveDate;
    NSString * _email;
}
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation DDUserComanyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业资料";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [self getIndustryData];
    [self getEnterpriseData];
}

- (void)getEnterpriseData{
    if ([DDUserManager share].user.enterprise != -1) {
        [DDHub hub:self.view];
        @weakify(self)
        [[DDAppNetwork share] get:YES
                             path:YYFormat(@"/uas/user/enterprise/getUserEnterpriseeInfo?id=", @([DDUserManager share].user.enterprise))
                             body:@""
                       completion:^(NSInteger code, NSString *message, id data) {
                           @strongify(self)
                           if (!self) return ;
                           if (code == 200 && data && [data isKindOfClass:[NSDictionary class]]) {
                               self->_enterpriseName = data[@"enterpriseName"];
                               self->_enterpriseAddress = data[@"enterpriseAddress"];
                               self->_registrationNumber = data[@"registrationNumber"];
                               self->_socialCreditCode = data[@"socialCreditCode"];
                               self->_legalRepresentative = data[@"legalRepresentative"];
                               self->_effectiveDate = data[@"effectiveDate"];
                               self->_currentIndustryname = data[@"industry"];
                               self->_email = data[@"compayEmail"];
                               self->_serviceURL = data[@"authBookUrl"];
                               self->_enterpriseImgUrl = data[@"compayBusinessLicense"];
                               self->_email = data[@"compayEmail"];
                               
                               [self.tableView reloadData];
                               [DDHub dismiss:self.view];
                           }else {
                               [DDHub dismiss:self.view];
                           }
                       }];
    }
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorHex(0xf0f0f0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DDUserAvatarCell" bundle:nil] forCellReuseIdentifier:@"DDUserAvatarCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDBaseCell" bundle:nil] forCellReuseIdentifier:@"DDBaseCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDCommitCell" bundle:nil] forCellReuseIdentifier:@"DDCommitCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDDownServceCell" bundle:nil] forCellReuseIdentifier:@"DDDownServceCellId"];
        [_tableView registerNib:[UINib nibWithNibName:@"DDBaseInputCell" bundle:nil] forCellReuseIdentifier:@"DDBaseInputCellId"];
        // DDBaseInputCell
        // DDDownServceCell
    }
    return _tableView;
}

- (void)topMenuView:(NSInteger)type{
    
}

// 获取所属行业信息
- (void)getIndustryData{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/uas/enterprise/industry/getIndustryList?token=", [DDUserManager share].user.token)
                         body:@""
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           NSMutableArray * industry = @[].mutableCopy;
                           NSMutableArray * industryName = @[].mutableCopy;
                           if ([data isKindOfClass:[NSArray class]]) {
                               for (NSDictionary * dic in (NSArray *)data) {
                                   DDIndustryModel * model = [DDIndustryModel modelWithJSON:dic];
                                   [industryName addObject:yyTrimNullText(model.name)];
                                   [industry addObject:model];
                               }
                           }
                           self->_industrys = industry;
                           self->_industryNames = industryName;
                       }
                   }];
}



// 验证
- (void)uploadEnterpriseCertification{
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
        [self uploadImage:[images firstObject]
               completion:^(bool suc, NSString *url) {
                   if (suc) {
                       if (self->_isEnterpriseImgUrl) {
                           self->_enterpriseImgUrl = url;
                            [self getScanCompanyRequest:url];
                       }else {
                           self->_serviceURL = url;
                           [DDHub dismiss:self.view];
                       }
                       [self.tableView reloadData];
                      
                   }else {
                       [DDHub hub:@"识别失败！" view:self.view];
                   }
        }];
    }];
    
    actionSheet.sender = self;
    actionSheet.cancleBlock = ^{
        NSLog(@"取消选择图片");
    };
    [actionSheet showPreviewAnimated:YES];
}

// 开始认证
- (void)startVerifyComany{

    if (!_enterpriseImgUrl) {
        [DDHub hub:@"请上传高清营业执照开始认证！" view:self.view];
        [self uploadEnterpriseCertification];
        return;
    }
//    if (_serviceURL.length == 0) {
//        [DDHub hub:@"请上传授权服务书！" view:self.view];
//        return;
//    }
    if (_email.length == 0) {
        [DDHub hub:@"请添加邮箱！" view:self.view];
        return;
    }
    if (_enterpriseName.length == 0) {
        [DDHub hub:@"请输入企业名称！" view:self.view];
        return;
    }
    if (_enterpriseAddress.length == 0) {
        [DDHub hub:@"请输入地址！" view:self.view];
        return;
    }
    if (_socialCreditCode.length == 0) {
        [DDHub hub:@"请输入信用代码！" view:self.view];
        return;
    }
    if (_legalRepresentative.length == 0) {
        [DDHub hub:@"请输入法定代表！" view:self.view];
        return;
    }

    if (_currentIndustryname.length == 0) {
        [DDHub hub:@"请选择所属行业！" view:self.view];
        [self selectedIndustry];
        return;
    }
    [DDHub hub:self.view];
    NSString * body = [NSString stringWithFormat:@"{\"compayBusinessLicense\" : \"%@\" , \"industry\" : \"%@\" , \"enterpriseName\" : \"%@\" , \"enterpriseAddress\" : \"%@\", \"registrationNumber\" : \"%@\" ,\"socialCreditCode\" : \"%@\" ,\"legalRepresentative\" : \"%@\" , \"effectiveDate\" : \"%@\",\"compayEmail\" : \"%@\" ,\"authBookUrl\" : \"%@\"}",_enterpriseImgUrl,_currentIndustryname,_enterpriseName,_enterpriseAddress,_registrationNumber,_socialCreditCode,_legalRepresentative,_effectiveDate,_email,yyTrimNullText(_serviceURL)];
    @weakify(self)
    [[DDAppNetwork share] get:NO
                         path:YYFormat(@"/uas/user/enterprise/user/userInfo/enterpriseCertification?token=",
                                       [DDUserManager share].user.token)
                         body:body
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           [[DDUserManager share] getUserInfo:^{
//                               [self.tableView reloadData];
//                               [self getEnterpriseData];
                           }];
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                                        (int64_t)(1 * NSEC_PER_SEC)),
                                          dispatch_get_main_queue(), ^{
                               [self.navigationController popViewControllerAnimated:YES];
                           });
                           [DDHub hub:@"申请成功" view:self.view];
                       }else {
                           [DDHub hub:message view:self.view];
                       }
                   }];
}

// 识别营业执照
- (void)getScanCompanyRequest:(NSString *)url{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/uas/baidu/ai/scanCompany?url=",
                                       url)
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           if ([data isKindOfClass:[NSDictionary class]]) {
                               self->_enterpriseName = [data valueForKeyPath:@"words_result.单位名称.words"];
                               self->_enterpriseAddress = [data valueForKeyPath:@"words_result.地址.words"];
                               self->_registrationNumber = [data valueForKeyPath:@"words_result.证件编号.words"];
                               self->_socialCreditCode = [data valueForKeyPath:@"words_result.社会信用代码.words"];
                               self->_legalRepresentative = [data valueForKeyPath:@"words_result.法人.words"];
                               self->_effectiveDate = [data valueForKeyPath:@"words_result.有效期.words"];
                               [self.tableView reloadData];
                           }
                           [DDHub dismiss:self.view];
                       }else {
                           [DDHub hub:@"识别失败！" view:self.view];
                       }
                   }];
}

// 上传图片
- (void)uploadImage:(UIImage*)image completion:(void (^)(bool suc ,NSString * url ) )completion{
//  UIImage * imageUpload = [image imageByResizeToSize:CGSizeMake(1000, 1000)];
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] path:@"/uas/st/upload"
                        upload:image
                    completion:^(NSInteger code,
                                 NSString *message,
                                 id data) {
                        @strongify(self)
                        if (!self) return ;
                        if (code == 200) {
                            if (completion) completion(YES, message);
                        }else {
                            [DDHub dismiss:self.view];
                            if(completion) completion(NO, nil);
                        }
                    }];
}

// 选择行业
- (void)selectedIndustry{
    if (_industryNames.count == 0) {
        return;
    }
    @weakify(self)
    [BRStringPickerView showStringPickerWithTitle:@"所属行业"
                                       dataSource:_industryNames
                                  defaultSelValue:nil
                                      resultBlock:^(NSString * selectValue) {
                                          @strongify(self)
                                          if (!self) return ;
                                          for (DDIndustryModel * model in self->_industrys){
                                              if ([selectValue isEqualToString: model.name]){
                                                  self->_currentIndustryname = selectValue;
                                                  self->_currentIndustryId = model.ddId;
                                                  [self.tableView reloadData];
                                                  break;
                                              }
                                          }
                                  }];
}


- (void)downLoadServiceRequest{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:@"/uas//user/enterprise/get/authfile/junziqian"
                         body:@""
                   completion:^(NSInteger code, NSString *message,NSDictionary * data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200 ){
                           [DDHub dismiss:self.view];
                           [[SDWebImageManager sharedManager].imageLoader requestImageWithURL:[NSURL URLWithString:data[@"myfilepath"]] options:SDWebImageAvoidAutoSetImage
                                                                                      context:nil
                                                                                     progress:^(NSInteger receivedSize,
                                                                                                NSInteger expectedSize,
                                                                                                NSURL * _Nullable targetURL) {
                               
                           } completed:^(UIImage * _Nullable image,
                                         NSData * _Nullable data,
                                         NSError * _Nullable error,
                                         BOOL finished) {
                               @strongify(self)
                               if (image) {
                                   UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

                               }
                           }];
                       }else {
                           [DDHub hub:message view:self.view];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return 10;
    if ([DDUserManager share].user.enterpriseAuthentication == 1 || [DDUserManager share].user.enterpriseAuthentication == 0) {
        return 2;
    }
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.section == 0 &&(indexPath.row == 0 ||indexPath.row == 1)) {
        DDUserAvatarCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDUserAvatarCellId"];
        cell.dictView.image = nil;
        cell.nameLb.text = indexPath.row == 0 ? @"请上传高清营业执照" : @"授权服务书";
        if (indexPath.row == 0) {
            if (yyTrimNullText(_enterpriseImgUrl) && [yyTrimNullText(_enterpriseImgUrl) hasPrefix:@"http"]) {
                [cell.iconView sd_setImageWithURL:[NSURL URLWithString:_enterpriseImgUrl]];
            }else {
                cell.iconView.image = [UIImage imageNamed:@"icon_carmar"];
            }
        }else {
            if (yyTrimNullText(_serviceURL) && [yyTrimNullText(_serviceURL) hasPrefix:@"http"]) {
                [cell.iconView sd_setImageWithURL:[NSURL URLWithString:_serviceURL]];
            }else {
                cell.iconView.image = [UIImage imageNamed:@"icon_carmar"];
            }
        }
        cell.iconView.backgroundColor = [UIColor clearColor];
        
        cell.widthCons.constant = 25;
        cell.iconView.layer.cornerRadius = 0;
        cell.heightCons.constant = 25;
        cell.clipsToBounds = YES;
        return cell;
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        DDCommitCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDCommitCellId"];
        [cell.commitBtn setTitle:@"申请认证" forState:UIControlStateNormal];
        cell.event = ^{
            @strongify(self)
            if (!self) return ;
            [self startVerifyComany];
        };
        return cell;
    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        DDDownServceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDDownServceCellId"];
        cell.clipsToBounds = YES;
        @weakify(self)
        cell.event = ^(NSInteger index) {
            @strongify(self)
            [self downLoadServiceRequest];
        };
        return cell;
    }
    
    DDBaseInputCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DDBaseInputCellId"];
    NSString * title = @"";
    NSString * content = @"";
    cell.dictView.hidden = YES;
    cell.contentLb.userInteractionEnabled = NO;
    cell.contentLb.placeholder = @"";
    cell.textLb.hidden = YES;
    if (indexPath.section == 0) {
        NSArray * titles = @[@"邮箱",@"企业名称",@"住址",@"注册号",@"社会信用代码",@"法定代表人",@"有效日期"];
        NSArray * contents = @[ yyTrimNullText(_email),
                                yyTrimNullText(_enterpriseName),
                                yyTrimNullText(_enterpriseAddress),
                                yyTrimNullText(_registrationNumber),
                                yyTrimNullText(_socialCreditCode),
                                yyTrimNullText(_legalRepresentative),
                                yyTrimNullText(_effectiveDate)];
        title = titles[indexPath.row - 3];
        content = contents[indexPath.row - 3];
        // 邮箱
        if (indexPath.row == 3) {
            cell.contentLb.userInteractionEnabled = NO;
            if ([DDUserManager share].user.enterpriseAuthentication != 1){
                cell.dictView.hidden = NO;
            }
            
            if (yyTrimNullText(_email).length == 0) {
                content = @"请填写邮箱";
            }
        }else {
            cell.contentLb.userInteractionEnabled = YES;
        }
        cell.contentLb.placeholder = [NSString stringWithFormat:@"请输入%@",title];
        cell.indexPath = indexPath;
        @weakify(self)
        cell.textChange = ^(NSString *text, NSIndexPath *index) {
            @strongify(self)
            if (index.row == 4) {
                self->_enterpriseName = text;
            }else if (index.row == 5) {
                self->_enterpriseAddress = text;
            }else if (index.row == 6) {
                self->_registrationNumber = text;
            }else if (index.row == 7) {
                self->_socialCreditCode = text;
            }else if (index.row == 8) {
                self->_legalRepresentative = text;
            }else if (index.row == 8) {
                self->_effectiveDate = text;
            }
        };
    }else {
        NSArray * titles = @[@"企业认证",@"所属行业"];
        NSString * status = @"未认证";
        if ([DDUserManager share].user.enterpriseAuthentication == 1){
            status = @"已认证";
        }else if([DDUserManager share].user.enterpriseAuthentication == 2) {
            status = @"未通过";
        }else if([DDUserManager share].user.enterpriseAuthentication == 0) {
            status = @"认证中";
        }
        NSArray * contents = @[status,yyTrimNullText(_currentIndustryname)];
        title = titles[indexPath.row];
        if (indexPath.row == 1) {
            if ([DDUserManager share].user.enterpriseAuthentication != 1){
                cell.dictView.hidden = NO;
            }
        }
        content = contents[indexPath.row];
    }
    cell.nameLb.text = title;
    if ([DDUserManager share].user.enterpriseAuthentication == 1) {
        cell.contentLb.userInteractionEnabled = NO;
        cell.textLb.hidden = NO;
        cell.contentLb.hidden =YES;
        cell.textLb.text = content;
    }else {
        cell.contentLb.text = content;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([DDUserManager share].user.enterpriseAuthentication == 1) {
        if (indexPath.section == 1 && indexPath.row == 2) return 0.01;
        if (indexPath.section == 0 && indexPath.row == 2) return 0.01;
    }
    if ((indexPath.row == 0 ) && indexPath.section == 0) return 70;
    if ((indexPath.row == 1 ) && indexPath.section == 0) return 0.00;
    if ((indexPath.row == 2 ) && indexPath.section == 0) return 0.00;
    if (indexPath.section == 1 && indexPath.row == 2) return 80;
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([DDUserManager share].user.enterpriseAuthentication == 1) {
        return;
    }
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1)){
        _isEnterpriseImgUrl = indexPath.row  == 0;
        [self uploadEnterpriseCertification];
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        [self selectedIndustry];
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        [self modifyEmail];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
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
        self->_email = text;
        [self.tableView reloadData];
    };
    sheetView.titleLb.text = @"填写邮箱";
    sheetView.textLb.placeholder = @"请输入您邮箱";
    sheetView.textLb.text = yyTrimNullText(_email);
    if (iPhoneXAfter) {
        sheetView.height = 190;
    }
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:sheetView preferredStyle:TYAlertControllerStyleActionSheet];
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}



@end
