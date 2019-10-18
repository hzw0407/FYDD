//
//  DDClerkVerifyVC.m
//  FYDD
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDClerkVerifyVC.h"
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>
#import <UIImage+YYAdd.h>
#import <UIImageView+WebCache.h>
@interface DDClerkVerifyVC (){
    NSString * _url;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTd;
@property (weak, nonatomic) IBOutlet UITextField *numberTd;

@property (weak, nonatomic) IBOutlet UITextField *memberLb;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIView *commitView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UITextField *statusLb;
@end

@implementation DDClerkVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实施方认证";
    _button1.layer.borderWidth = 1;
    _button1.layer.borderColor = UIColorHex(0x549BF3).CGColor;
    _button2.layer.borderWidth = 1;
    _button2.layer.borderColor = UIColorHex(0x8C9FAD).CGColor;
    if ([DDUserManager share].user.isAuth == 1) {
        _commitView.hidden = YES;
        _memberLb.userInteractionEnabled = NO;
    }
    if ([DDUserManager share].user.isAuth == 2) {
        [_commitBtn setTitle:@"重新认证" forState:UIControlStateNormal];
    }
    _memberLb.text = yyTrimNullText([DDUserManager share].user.qualificationNo);
    _url = yyTrimNullText([DDUserManager share].user.contractImgPath);
    [self updateQualification];
    [self getUserData];
    if([DDUserManager share].user.isAuth == -1) {
        _statusLb.text = @"未认证";
    }else if([DDUserManager share].user.isAuth == 0) {
        _statusLb.text = @"未认证";
    }else if([DDUserManager share].user.isAuth == 1) {
        _statusLb.text = @"已认证";
    }else if([DDUserManager share].user.isAuth == 2) {
        _statusLb.text = @"未通过";
    }
}

- (void)updateQualification{
    if (_url && [_url rangeOfString:@"http"].location != NSNotFound) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:_url]];
    }
}

- (void)getUserData{
    // 获取实施方认证信息
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:YYFormat(@"/uas/user/user/setter/getIdentifyInfo?token=",
                                       [DDUserManager share].user.token)
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       [DDHub dismiss:self.view];
                       if (code == 200) {
                           self.phoneTd.text = data[@"mobile"];
                           self.numberTd.text = data[@"cardNo"];
                       }else {
                          
                       }
                   }];
}

- (IBAction)buttonDidClick:(UIButton *)sender {
    [self.view endEditing:YES];
    // 上传合同
    if (sender.tag == 2) {
        @weakify(self)
        [self showPhotoActionSheetCompletion:^(bool suc, NSString *url) {
            @strongify(self)
            if (!self) return ;
            if (suc) {
                self->_url = url;
                [self updateQualification];
                [DDHub hub:@"上传成功！" view:self.view];
            }else {
                [DDHub hub:@"上传失败！" view:self.view];
            }
        }];
    // 下载合同模板
    }else if (sender.tag == 3) {
        [self downLoadServiceRequest];
    // 申请认证
    }else if (sender.tag == 4) {
        
        if (_memberLb.text.length == 0) {
            [DDHub hub:@"请输入资格证编号" view:self.view];
            return;
        }
        if (_url.length == 0) {
            [DDHub hub:@"请上传合同" view:self.view];
            return;
        }
        NSString * body = [NSString stringWithFormat:@"{\"qualificationNo\" : \"%@\" , \"contractUrl\" : \"%@\" }",_memberLb.text,_url];
        
        @weakify(self)
        [[DDAppNetwork share] get:NO
                             path:YYFormat(@"/uas/user/online/user/setter/userIdentify?token=",
                                           [DDUserManager share].user.token)
                             body:body
                       completion:^(NSInteger code, NSString *message, id data) {
                           @strongify(self)
                           if (!self) return ;
                           if (code == 200) {
                               [DDHub hub:@"提交成功" view:self.view];
                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   [self.navigationController popViewControllerAnimated:YES];
                               });
                           }else {
                               [DDHub hub:message view:self.view];
                           }
                       }];
    }
    
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


- (void)downLoadServiceRequest{
    [DDHub hub:self.view];
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:@"/uas/user/online/get/appfile"
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


@end
