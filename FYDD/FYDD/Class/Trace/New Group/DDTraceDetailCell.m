//
//  DDTraceDetailCell.m
//  FYDD
//
//  Created by wenyang on 2019/9/12.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDTraceDetailCell.h"
#import <SDWebImage/SDWebImage.h>
@implementation DDTraceDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
//    //这个属性不加,webview会显示很大.
    _webView.backgroundColor = [UIColor whiteColor];
//    _webView.scalesPageToFit = YES;
    _webView.opaque =NO;
}


- (void)setStripObj:(DDFootstripObj *)stripObj{
    _stripObj = stripObj;
    _titleTextLb.text = stripObj.title;
    _userNameLb.text = stripObj.createUserName;
    if ([stripObj.updateTime componentsSeparatedByString:@" "].count > 0) {
        _dateLb.text = [stripObj.updateTime componentsSeparatedByString:@" "][0];
    }
    if ([stripObj.updateTime componentsSeparatedByString:@"T"].count > 0) {
        _dateLb.text = [stripObj.updateTime componentsSeparatedByString:@"T"][0];
    }
    if (yyTrimNullText(stripObj.createUserLogo).length > 0) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:stripObj.createUserLogo]];
    }else {
        _iconView.image = [UIImage imageNamed:[DDUserManager share].userPlaceImage];
    }
    if ([_stripObj.contents rangeOfString:@"<"].location != NSNotFound && [_stripObj.contents rangeOfString:@"</"].location != NSNotFound){
        _webView.hidden = NO;
        [_webView loadHTMLString:stripObj.contents baseURL:nil];
        return;
    }
    
    _titleHeightCons.constant = stripObj.titleHeight;
    _contentHeightCons.constant = stripObj.contentHeight;
    _contentLb.text = stripObj.contents;
    [_picImageContentView removeAllSubviews];

   
    CGFloat left = 10;
    CGFloat top = 0;
    NSArray * showImage = [stripObj.showImage componentsSeparatedByString:@"|"];
    for (NSInteger i =0; i < showImage.count; i++){
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.size = stripObj.imageSize;
        switch (showImage.count) {
            case 1:
                break;
            case 2:
            case 3:
            case 4:
                left = (stripObj.imageSize.width + 10) * (int)(i % 2);
                top = (stripObj.imageSize.height + 10) * (int)(i  / 2);
                break;
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            default:
                left = (stripObj.imageSize.width + 10) * (i % 3);
                top =  (stripObj.imageSize.height + 10) * (int)(i  / 3 );
                break;
        }
        button.left = left;
        button.top = top;
        [button sd_setImageWithURL:[NSURL URLWithString:showImage[i]] forState:UIControlStateNormal];
        [self.picImageContentView addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(orginButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)orginButtonDidClick:(UIButton *)btn{
    NSArray * showImage = [_stripObj.showImage componentsSeparatedByString:@"|"];
    if (_interactObj) {
        showImage = [_interactObj.showImage componentsSeparatedByString:@"|"];
    }
    NSString * url = showImage[btn.tag];
    if (_contentImageDidClick) {
        _contentImageDidClick(btn,url);
    }
}

- (void)setInteractObj:(DDInteractObj *)interactObj{
    _interactObj = interactObj;
    _titleTextLb.text = interactObj.title;
    _titleHeightCons.constant = interactObj.titleHeight;
    _contentHeightCons.constant = interactObj.contentHeight;
    _contentLb.text = interactObj.contents;
    [_picImageContentView removeAllSubviews];
    if (yyTrimNullText(interactObj.createUserLogo).length > 0) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:interactObj.createUserLogo]];
    }else {
        _iconView.image = [UIImage imageNamed:[DDUserManager share].userPlaceImage];
    }
    _userNameLb.text = interactObj.createUserName;
    if ([interactObj.updateTime componentsSeparatedByString:@" "].count > 0) {
        _dateLb.text = [interactObj.updateTime componentsSeparatedByString:@" "][0];
    }
    
    CGFloat left = 10;
    CGFloat top = 0;
    NSArray * showImage = [interactObj.showImage componentsSeparatedByString:@"|"];
    for (NSInteger i =0; i < showImage.count; i++){
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.size = interactObj.imageSize;
        switch (showImage.count) {
            case 1:
                break;
            case 2:
            case 3:
            case 4:
                left = (interactObj.imageSize.width + 10) * (int)(i % 2);
                top = (interactObj.imageSize.height + 10) * (int)(i  / 2);
                break;
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            default:
                left = (interactObj.imageSize.width + 10) * (i % 3);
                top =  (interactObj.imageSize.height + 10) * (int)(i  / 3 );
                break;
        }
        button.left = left;
        button.top = top;
        [button sd_setImageWithURL:[NSURL URLWithString:showImage[i]] forState:UIControlStateNormal];
        [self.picImageContentView addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(orginButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *jsStr = [NSString stringWithFormat:
                       @"var script = document.createElement('script');"
                       "script.type = 'text/javascript';"
                       "script.text = \"function ResizeImages() { "
                       "var myimg,oldwidth,oldheight;"
                       "var width=%f;"
                       "for(var i=0;i <document.images.length;i++){"
                       "myimg = document.images[i];"
                       "oldwidth = myimg.width;"
                       "oldheight = myimg.height;"
                       "myimg.style.width = maxwidth+'px';"
                       "myimg.style.height = (oldheight * (maxwidth/oldwidth))+'px';"
                       "}"
                       "}\";"
                       "document.getElementsByTagName('head')[0].appendChild(script);",[UIScreen mainScreen].bounds.size.width - 20];
    
    [webView stringByEvaluatingJavaScriptFromString:jsStr];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    if (_stripObj == nil) return;
    CGFloat webViewHeight  = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"]floatValue];
    if (_contentHeight < webViewHeight) {
        _contentHeight = webViewHeight;
    }else {
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.stripObj.cellHeight = webViewHeight + 160;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WebViewHeightChange" object:nil];
    });
}



@end
