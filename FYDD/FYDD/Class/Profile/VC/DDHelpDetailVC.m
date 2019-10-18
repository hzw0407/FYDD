//
//  DDHelpDetailVC.m
//  FYDD
//
//  Created by mac on 2019/4/15.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDHelpDetailVC.h"

@interface DDHelpDetailVC ()<UIWebViewDelegate>
@property (nonatomic,strong) UIActivityIndicatorView * dicatorView;
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation DDHelpDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(@0);
    }];
    self.dicatorView = [[UIActivityIndicatorView alloc] init];
    [self.view addSubview:self.dicatorView];
    [self.dicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.webView);
    }];
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self detailData];
}

//获取产品详情数据
- (void)detailData{
    @weakify(self)
    [[DDAppNetwork share] get:YES
                         path:[NSString stringWithFormat:@"/uas/supervisor/manager/helpDetail?id=%zd",_helpId]
                         body:@""
                   completion:^(NSInteger code, NSString *message, id data) {
                       @strongify(self)
                       if (!self) return ;
                       if (code == 200) {
                          
                       }
                   }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _dicatorView.hidden = NO;
    [_dicatorView startAnimating];
     webView.hidden = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    _dicatorView.hidden = YES;
    [_dicatorView stopAnimating];
    NSString *jsStr = [NSString stringWithFormat:
                       @"var script = document.createElement('script');"
                       "script.type = 'text/javascript';"
                       "script.text = \"function ResizeImages() { "
                       "var myimg,oldwidth,oldheight;"
                       "var maxwidth=%f;" //缩放系数
                       "for(var i=0;i <document.images.length;i++){"
                       "myimg = document.images[i];"
                       "oldwidth = myimg.width;"
                       "oldheight = myimg.height;"
                       "myimg.style.width = maxwidth+'px';"
                       "myimg.style.height = (oldheight * (maxwidth/oldwidth))+'px';"
                       "}"
                       "}\";"
                       "document.getElementsByTagName('head')[0].appendChild(script);",[UIScreen mainScreen].bounds.size.width - 40];
    
    [webView stringByEvaluatingJavaScriptFromString:jsStr];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    webView.hidden = NO;
}

@end
