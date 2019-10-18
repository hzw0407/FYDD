//
//  DDWebVC.m
//  FYDD
//
//  Created by mac on 2019/4/3.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDWebVC.h"

@interface DDWebVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation DDWebVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _webView.mediaPlaybackRequiresUserAction = NO;
    _webView.allowsInlineMediaPlayback = YES;
    if (_url.length > 0 && [_url hasPrefix:@"http"]) {
        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]]];
    }else if (_htmlText) {
        [_webView loadHTMLString:_htmlText baseURL:nil];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    _webView.hidden = YES;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:false];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_indicatorView startAnimating];
    _indicatorView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_indicatorView stopAnimating];
    _indicatorView.hidden = YES;
    _webView.hidden = NO;
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
                       "myimg.style.height = 'auto';"
                       "myimg.style.margin = '0px';"
                       "}"
                       "}\";"
                       "document.getElementsByTagName('head')[0].appendChild(script);",[UIScreen mainScreen].bounds.size.width - 40];
    [webView stringByEvaluatingJavaScriptFromString:jsStr];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_indicatorView stopAnimating];
    _indicatorView.hidden = YES;
}

@end
