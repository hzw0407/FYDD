//
//  DDWebContentVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/3.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDWebContentVc.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

@interface DDWebContentVc ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation DDWebContentVc

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.url) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_reward"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnDidClick)];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityView startAnimating];
    self.activityView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
}

-(void)shareBtnDidClick{
    @weakify(self)
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType,
                                                                             NSDictionary *userInfo) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:yyTrimNullText(self.title)
                                                                                 descr:@""
                                                                             thumImage:[UIImage imageNamed:@"index_place"]];
        shareObject.webpageUrl = self.url;
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

@end
