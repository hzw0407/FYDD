//
//  DDTraceDetailCell.h
//  FYDD
//
//  Created by wenyang on 2019/9/12.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFootstripObj.h"
#import "DDInteractObj.h"

@interface DDTraceDetailCell : UITableViewCell <UIWebViewDelegate> {
    NSInteger _contentHeight;
}
@property (weak, nonatomic) IBOutlet UILabel *titleTextLb;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIScrollView *picImageContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightCons;

@property (nonatomic,strong) DDFootstripObj * stripObj;
@property (nonatomic,strong) DDInteractObj * interactObj;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,copy) void (^contentImageDidClick)(UIButton * originButton,NSString * url);
@end


