//
//  DDProductDetailVC.m
//  FYDD
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProductDetailVC.h"
#import "DDProductOrderVC.h"
#import "DDProductItem.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import "DDAuthenticationIdCardVcView.h"
#import "DDUserComanyInfoVC.h"
#import "DDProductCreateOrderVc.h"
#import "DDAlertInputView.h"
#import "DDAlertView.h"
#import "DDChangeUserTypeVC.h"

@interface DDProductDetailVC () <UIWebViewDelegate>{

    __weak IBOutlet UIWebView *webView;
    __weak IBOutlet UIActivityIndicatorView *stateView;
    DDProductDetailObj * _detailObj;
    BOOL _isFree;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBarCons;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIButton *barButton;
@property (weak, nonatomic) IBOutlet UIView *barTinColor;
@property (weak, nonatomic) IBOutlet UILabel *barLb1;
@property (weak, nonatomic) IBOutlet UILabel *barLb2;
@end

@implementation DDProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    if ([DDUserManager share].isLogged &&
//        [DDUserManager share].user.isExtensionUser == 1){
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_reward"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonDidClick)];
//    }
    if (iPhoneXAfter) {
        _bottomBarCons.constant =  100;
    }
    self.title = _item.productName;
    [self getProductDetailData];
    
    
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.barView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.20].CGColor;
    self.barView.layer.shadowOffset = CGSizeMake(0,6);
    self.barView.layer.shadowRadius = 22;
    self.barView.layer.shadowOpacity = 1;
    self.barView.hidden = YES;
}

//获取产品详情数据
- (void)getProductDetailData{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/tss/product/selectDetails?productId=%zd&token=%@",_item.objId,[DDUserManager share].user.token]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           self->_detailObj = [DDProductDetailObj modelWithJSON:data];
                           NSString * htm = [NSString stringWithFormat: @"<style> body, h1, h2, h3, h4, h5, h6, hr, p, blockquote, dl, dt, dd, ul, ol, li, pre, form, fieldset, legend, button, input, textarea, th, td { margin:0; padding:0; } </style> %@" ,self->_detailObj.productDetails];
                           [self->webView loadHTMLString:htm baseURL:nil];

                           [self getProductShopMai];
                       }
                   }];
   
}

// 判断产品有没有购买过
- (void)getProductShopMai{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/tss/orders/selectComOrderNumber?productId=%zd&comId=%zd&token=%@",_item.objId,[DDUserManager share].user.enterprise,[DDUserManager share].user.token]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                           self.barView.hidden = NO;
                           NSInteger count = [[NSString stringWithFormat:@"%@",data] integerValue];
                           [self updateBarUI:count < 1];
                       }
                   }];

}

- (void)updateBarUI:(BOOL)isNoGou{
    _isFree = isNoGou;
    // 免费版
    [self.barButton setTitle:@"" forState:UIControlStateNormal];
    if (_item.salePrice == 0) {
        // 未购买过
        if (isNoGou) {
            self.barLb1.text = @"";
            self.barLb2.text = @"";
            [self.barButton setTitle:@"申请试用" forState:UIControlStateNormal];
        }else {
            self.barButton.userInteractionEnabled = NO;
            self.barLb1.text = @"终身免费试用";
            self.barLb2.text = @"(免费版只能购买一次)";
            self.barLb1.textColor = UIColorHex(0xEF8200);
            self.barLb2.textColor = UIColorHex(0xEF8200);
            self.barTinColor.backgroundColor = [UIColor whiteColor];
        }
    }else{
        self.barLb1.text = [NSString stringWithFormat:@"原价%.f元/%.f折,现价%.f元",_item.salePrice * 100 / _item.discount,_item.discount/10,_item.salePrice];
        if (isNoGou) {
            self.barLb2.text = [NSString stringWithFormat:@"申请试用 (免费试用%zd天)",_detailObj.testUseTime];
        }else {
            self.barLb2.text = @"立即下单";
        }
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[DDUserManager share] getUserInfo:^{
        
    }];
}

- (IBAction)buyEvent {
    // 是否登录
    if ([DDUserManager share].isLogged) {
        
//        // 是否实名认证
//        if ([DDUserManager share].user.realAuthentication != 1) {
//            DDAuthenticationIdCardVcView * vc = [DDAuthenticationIdCardVcView new];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [DDHub hub:@"未实名认证，请先认证" view:vc.view];
//            });
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
//        // 企业认证
//        if ([DDUserManager share].user.enterpriseAuthentication != 1) {
//            DDUserComanyInfoVC * vc = [DDUserComanyInfoVC new];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [DDHub hub:@"未认证企业，请先认证" view:vc.view];
//            });
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
        // 如果没有上线，填入上线
        if (_detailObj.extensionName.length == 0) {
            [self bindingRewartCode];
            return;
        }
        if([DDUserManager share].user.userType != DDUserTypeSystem) {
            [DDAlertView showTitle:@""
                          subTitle:@"请切换至企业用户身份下单"
                         sureEvent:^{
                             DDChangeUserTypeVC * vc = [DDChangeUserTypeVC new];
                             vc.hidesBottomBarWhenPushed = YES;
                             [self.navigationController pushViewController:vc animated:YES];
            } cancelEvent:^{
                
            } autoSize:YES];
            return;
        }
        DDProductCreateOrderVc * vc = [DDProductCreateOrderVc new];
        vc.detailObj = self->_detailObj;
        vc.isFree = _isFree;
        [self.navigationController pushViewController:vc animated:true];
    }else {
        [self checkLoginStatus:nil];
    }
}

- (void)bindingRewartCode{
    @weakify(self)
    [DDAlertInputView showEvent:^(NSString *text) {
        [DDHub hub:self.view];
        [[DDAppNetwork share] get:YES
                             path:[NSString stringWithFormat:@"/uas/user/extension/setOrdersExtension?token=%@&extensionCode=%@",[DDUserManager share].user.token,text]
                             body:@""
                       completion:^(NSInteger code, NSString *message, id data) {
                           @strongify(self)
                           if (!self) return ;
                           [DDHub dismiss:self.view];
                           if (code == 200) {
                               DDProductCreateOrderVc * vc = [DDProductCreateOrderVc new];
                               vc.detailObj = self->_detailObj;
                               vc.isFree = self->_isFree;
                               [self.navigationController pushViewController:vc animated:true];
                           }else {
                               [DDHub hub:message view:self.view];
                           }
                       }];
        
    } cancelEvent:^{
        
    }];
}

                                                                                                                               
- (void)rightButtonDidClick{
    @weakify(self)
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType,
                                                                             NSDictionary *userInfo) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:yyTrimNullText(self->_detailObj.shareTitle)
                                                                                 descr:yyTrimNullText(self->_detailObj.shareContext)
                                                                             thumImage:yyTrimNullText(self->_detailObj.shareImage)];;
        shareObject.webpageUrl = yyTrimNullText(self->_detailObj.productSharePath);
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



- (void)webViewDidStartLoad:(UIWebView *)webView {
    stateView.hidden = NO;
    [stateView startAnimating];
    webView.hidden = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    stateView.hidden = YES;
    [stateView stopAnimating];
     webView.hidden = NO;
    NSString *jsStr = [NSString stringWithFormat:
                       @"var script = document.createElement('script');"
                       "script.type = 'text/javascript';"
                       "script.text = \"function ResizeImages() { "
                       "var myimg,oldwidth,oldheight;"
                       "var maxwidth=%f;" 
                       "for(var i=0;i <document.images.length;i++){"
                       "myimg = document.images[i];"
                       "oldwidth = myimg.width;"
                       "oldheight = myimg.height;"
                       "myimg.style.width = maxwidth+'px';"
                       "myimg.style.height = (oldheight * (maxwidth/oldwidth))+'px';"
                       "}"
                       "}\";"
                       "document.getElementsByTagName('head')[0].appendChild(script);",[UIScreen mainScreen].bounds.size.width];
    
    [webView stringByEvaluatingJavaScriptFromString:jsStr];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

@end
