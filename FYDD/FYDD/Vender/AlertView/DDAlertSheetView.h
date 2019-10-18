//
//  DDAlertSheetView.h
//  FYDD
//
//  Created by mac on 2019/3/16.
//  Copyright © 2019 www.sante.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDAlertSheetView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UITextField *textLb;
@property (copy ,nonatomic) void (^event)(NSString *text);
@end

NS_ASSUME_NONNULL_END
