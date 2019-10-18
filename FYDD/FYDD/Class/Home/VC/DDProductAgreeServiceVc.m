//
//  DDProductAgreeServiceVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/8.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDProductAgreeServiceVc.h"
@interface DDProductAgreeServiceVc () <UIWebViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *animatedView;
@property (weak, nonatomic) IBOutlet UIButton *agrreButton;

@end

@implementation DDProductAgreeServiceVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scrollView.delegate = self;
    [_animatedView startAnimating];
    self.title = _serviceName;
    if (_url) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
    [_agrreButton setTitle:[NSString stringWithFormat:@"我已仔细阅读并同意%@",_serviceName] forState:UIControlStateNormal];
    _agrreButton.userInteractionEnabled = NO;
}
- (IBAction)commitButtonDidClick:(UIButton *)sender {
    if (self.argeeServiceBlock) {
        self.argeeServiceBlock(YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_animatedView stopAnimating];
    _animatedView.hidden = YES;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= kScreenSize.height-60) {
        _agrreButton.userInteractionEnabled = YES;
        _agrreButton.backgroundColor = UIColorHex(0x2996EB);

    }
}

@end
