//
//  DDLADetailVc.m
//  FYDD
//
//  Created by wenyang on 2019/9/6.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDLADetailVc.h"

@interface DDLADetailVc ()
@property (weak, nonatomic) IBOutlet UILabel *textLb;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation DDLADetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"授权";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存证书" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarDidClick)];
    [self getVerifyCodeData];
}

- (void)rightBarDidClick{
    UIImageWriteToSavedPhotosAlbum([self makeImageWithView:_contentView], self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
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

- (void)getVerifyCodeData{
    NSString * url = [NSString stringWithFormat:@"%@:8000/user/getCertificationInfo?identityType=%@&token=%@",DDAPP_URL,_userType == DDUserTypePromoter ? @"2" : @"1",[DDUserManager share].user.token];
    [[DDAppNetwork share] get:YES
                          url:url
                         body:nil
                   completion:^(NSInteger code,
                                NSString *message,
                                id data) {
                       if (code == 200) {
                           NSString * userName = data[@"userName"];
                           NSString * qualificationNo = data[@"qualificationNo"];
                           if(yyTrimNullText(userName).length == 0 || yyTrimNullText(qualificationNo).length == 0) {
                               return ;
                           }
                           [self updateVerifyUI:userName qualificationNo:qualificationNo];
                       }else {
                           
                       }
    }];
}




- (void)updateVerifyUI:(NSString *)userName qualificationNo:(NSString *)qualificationNo{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"      兹授权 " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: UIColorHex(0x131313)}];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:userName attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: UIColorHex(0x2996EB)}];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@" 为我公司指定产品实施员，实施的产品范围：制造版、集团版、商贸版;\n" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: UIColorHex(0x131313)}];
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@" 特此授权，授权码;\n" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: UIColorHex(0x131313)}];
    NSMutableAttributedString *string4 = [[NSMutableAttributedString alloc] initWithString:yyTrimNullText(qualificationNo) attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: UIColorHex(0x2996EB)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 15; // 调整行间距
    [string appendAttributedString:string1];
    [string appendAttributedString:string2];
    [string appendAttributedString:string3];
    [string appendAttributedString:string4];
    NSRange range = NSMakeRange(0, [string length] - 1);
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
     _textLb.attributedText = string;
     _textLb.alpha = 1.0;
}

@end
