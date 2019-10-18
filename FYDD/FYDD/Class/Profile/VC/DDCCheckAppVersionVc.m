//
//  DDCCheckAppVersionVc.m
//  FYDD
//
//  Created by mac on 2019/5/5.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import "DDCCheckAppVersionVc.h"

@interface DDCCheckAppVersionVc ()
@property (weak, nonatomic) IBOutlet UILabel *versionLb;

@end

@implementation DDCCheckAppVersionVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"版本更新";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _versionLb.text = [NSString stringWithFormat:@"当前版本: %@",app_Version];
}
- (IBAction)buttonDidClick {
    [[DDAppNetwork share] checkAppVersion:^{
        
    } isShowAll:YES];
}


@end
