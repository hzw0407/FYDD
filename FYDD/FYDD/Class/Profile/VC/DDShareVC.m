//
//  DDShareVC.m
//  FYDD
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDShareVC.h"
#import <ZXingObjC/ZXingObjC.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import "DDAlertView.h"
@interface DDShareVC (){
    NSString * _extensionCode;
    NSString * _extensionURL;
    NSString * _shareContent;
    NSString * _shareTitle;
    NSString * _shareImage;
    BOOL _isLong;
}
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *inviteCodeLb;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation DDShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代理码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnDidClick)];
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = UIColorHex(0xEFEFEF).CGColor;

    
    // 获取推广码
//    @weakify(self)
//    [DDHub hub:self.view];
//    [[DDAppNetwork share] get:YES
//                         path:YYFormat(@"/uas/user/extension/user/extensionAgent/getUserAgentCode?token=", [DDUserManager share].user.token)
//                         body:@""
//                   completion:^(NSInteger code, NSString *message, NSDictionary * data) {
//                       @strongify(self)
//                       if (!self) return ;
//                       [DDHub dismiss:self.view];
//                       if (code == 200) {
//                           self->_extensionCode = data[@"extensionCode"];
//                           self->_extensionURL = data[@"userExtPath"];
//                           self->_shareContent = data[@"shareContent"];
//                           self->_shareTitle = data[@"shareTitle"];
//                           self->_shareImage = data[@"shareImage"];
//                           [self updateUI];
//                       }
//                   }];
    [self getInvitationCode];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longClick)];
    
    longPress.minimumPressDuration=0.2;
    
    [self.view addGestureRecognizer:longPress];
}

//获取邀请码
- (void)getInvitationCode {
    [DDHub hub:self.view];
    STHttpRequestManager *manager = [STHttpRequestManager shareManager];
    [manager addParameterWithKey:@"token" withValue:[DDUserManager share].user.token];
    [manager requestDataWithUrl:[NSString stringWithFormat:@"%@:%@%@",DDAPP_URL,DDPort7001,GETINVITATIONCODE] withType:RequestGet withSuccess:^(NSDictionary * _Nonnull dict) {
        [DDHub dismiss:self.view];
        if (dict && [dict[@"code"] integerValue] == 200) {
            self->_extensionCode = dict[@"data"][@"extensionCode"];
            self->_extensionURL = dict[@"data"][@"userExtPath"];
            self->_shareContent = dict[@"data"][@"shareContent"];
            self->_shareTitle = dict[@"data"][@"shareTitle"];
            self->_shareImage = dict[@"data"][@"shareImage"];
            [self updateUI];
        }
    } withFail:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [DDHub dismiss:self.view];
        [DDHub hub:error.domain view:self.view];
    }];
}

- (void)longClick{
    if (_isLong) return;
    _isLong = YES;
    @weakify(self)
    [DDAlertView showTitle:@"" subTitle:@"保存代理码图片" sureEvent:^{
        @strongify(self)
        [self rightBarDidClick];
        self->_isLong = NO;
    } cancelEvent:^{
        self->_isLong = NO;
    } autoSize:YES];
}

- (void)rightBarDidClick{
    UIImageWriteToSavedPhotosAlbum([self makeImageWithView:self.view], self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [DDHub hub:@"保存成功" view:self.view];
    }
}

- (UIImage *)makeImageWithView:(UIView *)view{
    CGSize s = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)shareBtnDidClick{
    @weakify(self)
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType,
                                                                             NSDictionary *userInfo) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self->_shareTitle
                                                                                 descr:self->_shareContent
                                                                             thumImage:self->_shareImage];
        shareObject.webpageUrl = self->_extensionURL;
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

- (void)updateUI{
    _inviteCodeLb.text = [NSString stringWithFormat:@"%@",_extensionCode];
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self)
        NSError *error = nil;
        ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
        ZXBitMatrix* result = [writer encode:self->_extensionURL
                                      format:kBarcodeFormatQRCode
                                       width:500
                                      height:500
                                       error:&error];
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGImageRef image = CGImageRetain([[ZXImage imageWithMatrix:result] cgimage]);
                if (image) {
                    self.iconView.image = [[UIImage alloc] initWithCGImage:image];
                }
                CGImageRelease(image);
            });
        } else {
            
        }
    });
}

@end
